`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    02:28:49 07/08/2016 
// Design Name: 
// Module Name:    i2c_master_wb_top 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module i2c_master_wb_top(
	input               clk,
	input               reset,
	// Wishbone bus
		// Wishbone bus
	input      [31:0]   wb_adr_i,
	input      [31:0]   wb_dat_i,
	output reg [31:0]   wb_dat_o,
	input      [ 3:0]   wb_sel_i,
	input               wb_cyc_i,
	input               wb_stb_i,
	output              wb_ack_o,
	input               wb_we_i,

	//I2C
	output Scl,
	inout wire Sda 
);

	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;


//-----------------------------------------------------------------------
//core i2c

wire  busy; 
reg [7:0] CAM = 8'hC3;
reg [7:0] CAL = 8'h83;
reg [7:0] AD1 = 8'h48;
reg [7:0] AD2 = 8'h01;
reg [7:0] AD3 = 8'h00;
reg [7:0] writei2c = 8'h01;
reg [7:0] stopi2c = 8'h00;

wire [7:0] A0M;
wire  [7:0] A0L;


I2c_1115 I2c_1115(
	.clk(clk),
        .reset(reset),	
	.busy(busy),
        .CAM(CAM),
	.CAL(CAL),
	.AD1(AD1),
	.AD2(AD2),
	.AD3(AD3),
	.writei2c(writei2c),
	.stopi2c(stopi2c),
	.A0M(A0M),
	.A0L(A0L),
	.Scl(Scl), 
  	.Sda(Sda)
);
	

  always @(posedge clk)begin
     if (reset)begin
        ack <= 0;
	CAM <= 8'hC3;
	CAL <= 8'h83;
     end
     else begin 
     ack <= wb_stb_i & wb_cyc_i;
			
    
        if (wb_rd & ~ack) begin             //Read cycle
         ack<=1;
         case(wb_adr_i[5:2])
	  4'b0000:begin  
            wb_dat_o[31:1]<=0;
            wb_dat_o[0] <= busy;
	  end
          4'b0001:begin  
            wb_dat_o[31:8]<=0;
            wb_dat_o[7:0] <= A0M;
          end
          4'b0010:begin  
            wb_dat_o[31:8]<=0;
            wb_dat_o[7:0] <= A0L;
          end
         endcase
        end

        else if (wb_wr & ~ack ) begin  
            ack <= 1;                          //Write cycle
            case(wb_adr_i[5:2])
           4'b0011: begin
	      CAM   <= wb_dat_i[7:0];
	     end
             4'b0100: begin
	      CAL   <= wb_dat_i[7:0];
             end
             4'b0101: begin
	      AD1   <= wb_dat_i[7:0];
             end
             4'b0110: begin
	      AD2   <= wb_dat_i[7:0];
             end
             4'b0111: begin
	      AD3   <= wb_dat_i[7:0];
             end
             4'b1000: begin
	      writei2c   <= wb_dat_i[7:0];
             end
             4'b1001: begin
	      stopi2c   <= wb_dat_i[7:0];
             end	     
            
            endcase
     end        
   end
end  

				
endmodule
