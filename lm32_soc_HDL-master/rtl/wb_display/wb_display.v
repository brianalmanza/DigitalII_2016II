`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:21:16 07/11/2016 
// Design Name: 
// Module Name:    wb_display 
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
module wb_display(
	input               clk,
	input               reset,
	// Wishbone bus
	input      [31:0]   wb_adr_i,
	input      [31:0]   wb_dat_i,
	output reg [31:0]   wb_dat_o,
	input      [3:0]    wb_sel_i,
	input               wb_cyc_i,
	input               wb_stb_i,
	output              wb_ack_o,
	input               wb_we_i,
	//display
	output  [7:0] seg,
	output  [3:0] anx
);

	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;

//---------------------------------------------------------
//display engine
		
reg [7:0]  A0M;
reg [7:0]  A0L;

display7 display7(
		.clk(clk),
		.reset(reset),
		.seg(seg),
		.anx(anx),
		.A0L(A0L),
		.A0M(A0M)
);

  always @(posedge clk)begin
     if (reset)begin
        A0M <= 0; // All set to in at reset
        A0L <= 0;
        ack <= 0;
     end
     else begin 
        ack<=0;
        if (wb_rd & ~ack) begin             //Read cycle
         ack<=1;
         case(wb_adr_i[3:2])
          2'b00:begin  
            wb_dat_o[31:8]<=0;
            wb_dat_o[7:0] <= A0M;
          end
          2'b01:begin  
            wb_dat_o[31:8]<=0;
            wb_dat_o[7:0] <= A0L;
          end
          default: wb_dat_o <= 32'b0; 
         endcase
        end

        else if (wb_wr & ~ack ) begin  
            ack <= 1;                          //Write cycle
            case(wb_adr_i[3:2])
             2'b10: A0M   <= wb_dat_i[7:0];
             2'b11: A0L   <= wb_dat_i[7:0];
            endcase
        end
     end        
   end   
				
endmodule
