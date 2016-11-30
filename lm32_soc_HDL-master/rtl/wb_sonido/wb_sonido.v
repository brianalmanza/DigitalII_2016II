//-----------------------------------------------------------------
// Sonido
//-----------------------------------------------------------------

module wb_sonido(
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
	// Sonido 
	output              clkout

);


	reg  ack;
	assign wb_ack_o = wb_stb_i & wb_cyc_i & ack;

	wire wb_rd = wb_stb_i & wb_cyc_i & ~ack & ~wb_we_i;
	wire wb_wr = wb_stb_i & wb_cyc_i & ~ack & wb_we_i;

//------------------------------------------------------------------
//core spi

//outputs
//nada
//inputs
reg [7:0] enable;


Alarma Alarma (.clk(clk),
	.reset(reset),
	.enable(enable),
	.clkout(clkout)

);




	
	always @(posedge clk) begin
		if (reset) begin
			ack <= 0;
			enable <= 0;
		end 
		else begin
		ack <= wb_stb_i & wb_cyc_i;



		if (wb_rd & ~ack) begin           // ciclo de lectura
		ack <= 1;
			case (wb_adr_i[5:2]) 
				4'b0000:begin 
					 wb_dat_o [31:8] <= 0;
					 wb_dat_o [7:0] <= enable;
					end

			endcase
		end
		
		else if (wb_wr & ~ack) begin           // ciclo de escritura 
		ack <=  1;
			case (wb_adr_i[5:2])
					4'b0001: enable <= wb_dat_i [7:0];
						

					

			endcase

	     end
	end
  end


endmodule
