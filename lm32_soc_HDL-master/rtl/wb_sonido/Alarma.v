`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    07:01:50 10/03/2016 
// Design Name: 
// Module Name:    Alarma 
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
module Alarma(input clk, input [7:0] enable, input wire reset,output clkout
    );
	 
reg [31:0]contador;
reg clk1;
assign clkout = clk2;


localparam inicio =0;
localparam inicio1 = 1;
localparam sonido = 2;
localparam fin = 3;

reg  [7:0] estado;
reg clk2;
reg clkin; // registro interno que permite avanzar al estado siguiente

always@(posedge clk)begin
if (reset == 1) begin
        clk1 = 0;
        contador = 0;
        end
        else begin
        
        if (contador == 63775) begin 
            clk1 = ~clk1;
            contador = 0;
        end
        else begin
        contador = contador + 1;
        end
    end
end 

always @(posedge clk1, negedge clk1) begin 
if( reset == 1)begin
	estado <= inicio;
	clk2 <= 0;
	clkin <= enable[0];
	end 
	
	else begin 
	
		case (estado)
		
			inicio:begin
			clk2 <= 0;
			clkin <= enable[0];
			estado<= inicio1;
			end
			
			inicio1:begin
			clk2 <= 1;
			if(clkin == 0) estado<= sonido;
			else estado<= inicio1;
			end 
			
			sonido:begin 
			clk2 <= 0;
			estado <= fin;
			end 
			
			fin: begin 
			clk2 <= 1;
			estado <= inicio;
			end
			
		endcase
	end 
end 
	

endmodule
