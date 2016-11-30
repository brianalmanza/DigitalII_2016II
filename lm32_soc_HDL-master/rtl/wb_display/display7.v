`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:23:21 07/11/2016 
// Design Name: 
// Module Name:    display7 
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
module display7(
    input clk,
    input reset,
	 input [7:0] A0M,
	 input [7:0] A0L,
	 output reg [3:0] anx,
    output reg [7:0] seg
    );
	 
reg [31:0] cont1 = 0;
reg div1;
reg [7:0] seg1;
reg [7:0] seg2;
reg [7:0] seg3;
reg [7:0] seg4;
reg [7:0] estado;
wire [3:0] sel1;
wire [3:0] sel2;
wire [3:0] sel3;
wire [3:0] sel4;

localparam inicio = 0;
localparam display1 = 1;
localparam display2 = 2;
localparam display3 = 3;
localparam display4 = 4;

assign sel1 = A0L[3:0];
assign sel2 = A0L[7:4];
assign sel3 = A0M[3:0];
assign sel4 = A0M[7:4];

always @(sel1)//display1
	case(sel1)
	'h0: seg1 = 'hC0;
	'h1: seg1 = 'hF9;
	'h2: seg1 = 'hA4;
	'h3: seg1 = 'hB0;
	'h4: seg1 = 'h99;
	'h5: seg1 = 'h92;
	'h6: seg1 = 'h82;
	'h7: seg1 = 'hF8;
	'h8: seg1 = 'h80;
	'h9: seg1 = 'h90;
	'hA: seg1 = 'h88;
	'hB: seg1 = 'h83;
	'hC: seg1 = 'hC6;
	'hD: seg1 = 'hA1;
	'hE: seg1 = 'h86;
	'hF: seg1 = 'h8E;
	default: seg1 = 'hFF;
	endcase
	
always @(sel2)//display2
	case(sel2)
	'h0: seg2 = 'hC0;
	'h1: seg2 = 'hF9;
	'h2: seg2 = 'hA4;
	'h3: seg2 = 'hB0;
	'h4: seg2 = 'h99;
	'h5: seg2 = 'h92;
	'h6: seg2 = 'h82;
	'h7: seg2 = 'hF8;
	'h8: seg2 = 'h80;
	'h9: seg2 = 'h90;
	'hA: seg2 = 'h88;
	'hB: seg2 = 'h83;
	'hC: seg2 = 'hC6;
	'hD: seg2 = 'hA1;
	'hE: seg2 = 'h86;
	'hF: seg2 = 'h8E;
	default: seg2 = 'hFF;
	endcase
	
always @(sel3)//display3
	case(sel3)
	'h0: seg3 = 'hC0;
	'h1: seg3 = 'hF9;
	'h2: seg3 = 'hA4;
	'h3: seg3 = 'hB0;
	'h4: seg3 = 'h99;
	'h5: seg3 = 'h92;
	'h6: seg3 = 'h82;
	'h7: seg3 = 'hF8;
	'h8: seg3 = 'h80;
	'h9: seg3 = 'h90;
	'hA: seg3 = 'h88;
	'hB: seg3 = 'h83;
	'hC: seg3 = 'hC6;
	'hD: seg3 = 'hA1;
	'hE: seg3 = 'h86;
	'hF: seg3 = 'h8E;
	default: seg3 = 'hFF;
	endcase
	
always @(sel4)//display4
	case(sel4)
	'h0: seg4 = 'hC0;
	'h1: seg4 = 'hF9;
	'h2: seg4 = 'hA4;
	'h3: seg4 = 'hB0;
	'h4: seg4 = 'h99;
	'h5: seg4 = 'h92;
	'h6: seg4 = 'h82;
	'h7: seg4 = 'hF8;
	'h8: seg4 = 'h80;
	'h9: seg4 = 'h90;
	'hA: seg4 = 'h88;
	'hB: seg4 = 'h83;
	'hC: seg4 = 'hC6;
	'hD: seg4 = 'hA1;
	'hE: seg4 = 'h86;
	'hF: seg4 = 'h8E;
	default: seg4 = 'hFF;
	endcase

always @(posedge clk) begin//Divisor 
        if (reset == 1) begin
        div1 = 0;
        cont1 = 0;
        end
        else begin
        
        if (cont1 == 100000) begin
            div1 = ~div1;
            cont1 = 0;
        end
        else begin
        cont1 = cont1 + 1;
        end
    end
 end 
 
always @(posedge div1) begin //maquina de estados displays
		if (reset == 1) begin 
		estado <= inicio;
		seg <= 8'hFF;
		anx <= 4'hF;
		end 
		else begin
		
		case(estado)

	   inicio: begin
		anx <= 4'b1111;
		seg <= 8'hFF;
		estado <= display1;
		end
	
	   
		display1: begin
		anx <= 4'b1110;
		seg <= seg1;
		estado <= display2;
		end
	
	
	   display2: begin
		anx <= 4'b1101;
		seg <= seg2;
		estado <= display3;
		end
	
		display3: begin
		anx <= 4'b1011;
		seg <= seg3;
		estado <= display4;
		end
	
	
	   display4: begin
		anx <= 4'b0111;
		seg <= seg4;
		estado <= inicio;
		end
	
	
  endcase
 end 
end
		
 
 


endmodule
