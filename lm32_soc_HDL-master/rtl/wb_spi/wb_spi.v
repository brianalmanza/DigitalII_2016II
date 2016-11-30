//-----------------------------------------------------------------
// SPI Master
//-----------------------------------------------------------------

module wb_spi(
	input               clk,
	input               reset,
	// Wishbone bus
	input      [31:0]   wb_adr_i,
	input      [31:0]   wb_dat_i,
	output reg [31:0]   wb_dat_o,
	input      [ 3:0]   wb_sel_i,
	input               wb_cyc_i,
	input               wb_stb_i,
	output              wb_ack_o,
	input               wb_we_i,
	// SPI 
	output              sck,
	output              mosi,
	input               miso,
	output              ce
);


	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;

//------------------------------------------------------------------
//core spi
//outputs
wire [7:0] sbusy;
wire [7:0] BYTEL;
wire [7:0] BYTEM;
//inputs
reg [7:0] CDIR1;
reg [7:0] CDIR2;
reg [7:0] CDIR3;
reg [7:0] CDIR4;
reg [7:0] writespi;
reg [7:0] stopspi;

spi spi(
	.clk(clk),
        .reset(reset),	
	.sbusy(sbusy),
	.miso(miso),
	.mosi(mosi),
	.sck(sck),
	.ce(ce),
	.BYTEL(BYTEL),
	.BYTEM(BYTEM),
	.CDIR1(CDIR1),
	.CDIR2(CDIR2),
	.CDIR3(CDIR3),
	.CDIR4(CDIR4),
	.writespi(writespi),
	.stopspi(stopspi)

        
);
	  always @(posedge clk)begin
    		if (reset)begin
       		 ack <= 0;
	     end
	     else begin 
	     ack <= wb_stb_i & wb_cyc_i;
			
    
        if (wb_rd & ~ack) begin             //Read cycle
         ack<=1;
         case(wb_adr_i[5:2])
	  4'b0000:begin  
            wb_dat_o[31:1]<=0;
            wb_dat_o[0] <= sbusy[0];
	  end
          4'b0001:begin  
            wb_dat_o[31:8]<=0;
            wb_dat_o[7:0] <= BYTEM;
          end
          4'b0010:begin  
            wb_dat_o[31:8]<=0;
            wb_dat_o[7:0] <= BYTEL;
          end
         endcase
        end

        else if (wb_wr & ~ack ) begin  
            ack <= 1;                          //Write cycle
            case(wb_adr_i[5:2])
             4'b0011: begin
	      CDIR1   <= wb_dat_i[7:0];
	     end
             4'b0100: begin
	      CDIR2   <= wb_dat_i[7:0]; 
             end
             4'b0101: begin
	      CDIR3   <= wb_dat_i[7:0];
             end
             4'b0110: begin
	      CDIR4   <= wb_dat_i[7:0];
             end
             4'b0111: begin
	      writespi   <= wb_dat_i[7:0];
             end
             4'b1000: begin
	      stopspi   <= wb_dat_i[7:0];
             end
	              
            endcase
     end        
   end
end  







endmodule
