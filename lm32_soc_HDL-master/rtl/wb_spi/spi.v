`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:17:00 09/13/2016 
// Design Name: 
// Module Name:    spi 
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
module spi(
    input wire miso,
    output   mosi,
    output   sck,
    output   ce,
    output reg [7:0] BYTEL,
    output reg [7:0] BYTEM,
    input wire [7:0] CDIR1,//80
    input wire [7:0] CDIR2,//E6
    input wire [7:0] CDIR3,//01
    input wire [7:0] CDIR4,//02
    input wire [7:0] writespi,
    input wire [7:0] stopspi,
    output [7:0] sbusy,    
    input wire clk,
    input wire  reset
    );
	 
	 localparam inicio = 0;
	 localparam inicio1 = 1;
	 localparam inicio2 = 2;
	 localparam escritura1= 3;
	 localparam descanso1 = 4;
	 localparam escritura2 = 5;
	 localparam descanso2 = 6;
	 localparam escritura3 = 7;
	 localparam descanso3 = 8;
	 localparam lectura1 = 9;
	 localparam descanso4 = 10;
	 localparam escritura4 =11;
	 localparam descanso5 = 12;
	 localparam lectura2 = 13;
	 localparam descanso6 = 14;
	 localparam descansob1 = 15;
	 localparam descansob2 = 16;
	 localparam descansob3 = 17;
	 

	 
	 
	 reg [7:0] state;
	 reg [7:0] count; // contador flancos de bajada del div1 escrituras
	 reg [7:0] count2; // contador flancos de bajada del div1 descansos largos
	 reg [7:0] count3; // contador para hacer el ce más largo 
	 reg [7:0] data1;
	 reg [7:0] data2;
	 reg [7:0] data3;
	 reg [7:0] data4;
	 reg [7:0] datar1;
	 reg [7:0] datar2;
	 reg misoo;
	 reg mosii; 
	 reg div1;
	 reg div2;
	 reg [30:0] cont2;
	 reg [30:0] cont1;
	 reg scke;
	 reg cen; 
	 reg bspi;
	 reg wspi;
	 reg sspi;
	 
	assign mosi = mosii;
	assign sck = div2;
	assign ce = cen;
	assign sbusy[0] = bspi;

	
	
	always @(posedge clk) begin//Divisor 5Mhz
        if (reset == 1) begin
        div1 = 0;
        cont1 = 0;
        end
        else begin
        
        if (cont1 == 9) begin 
            div1 = ~div1;
            cont1 = 0;
        end
        else begin
        cont1 = cont1 + 1;
        end
    end
 end   
 
	 always @(posedge (div1),negedge(div1),posedge(scke),negedge(scke)) begin
	 if(scke == 0) begin
	 div2 <= 1;
	 end 
	 else begin
	 if((scke == 1))begin
	 div2 <= div1;
	 end
	 end
	end
	


	
	 always @(negedge div1) begin
	 if(reset == 1) begin
		state <=inicio;
		data1 <=CDIR1;//80
		data2 <=CDIR2;//E6
		data3 <=CDIR3;//01
		data4 <=CDIR4;//02
		sspi <= 0;
		wspi <= 1;
		bspi <= 0;
		scke <= 0;
		cen <= 0;
		mosii <=0; 
	 end 
	 else begin 
		case(state)
		
			inicio: begin 
			data1 <=CDIR1;//80
			data2 <=CDIR2;//E6
			data3 <=CDIR3;//01
			data4 <=CDIR4;//02
			sspi <= 0;
		        wspi <= 1;
			mosii <= 0;
			bspi <= 0;
			count <=7;
			scke <= 0;
			cen <= 0;
		        state <= inicio1;
			end // cierrra el inicio  

			inicio1: begin 
			mosii <= 0;
	                bspi <= 1;
			scke <= 0;
			cen <= 1;
			if ((wspi == 1)&&(sspi == 0)) state <= escritura1;
			else state <= inicio1;
			end 

			/*inicio2: begin 
			mosii <= 0;
			scke <= 0;
			cen <= 1;
			if (sspi == 0) state <= escritura1;
			else state <=inicio2;
			end*/ 

			escritura1: begin 
			mosii <= data1[count];
			count2<= 1;
			scke <= 1;
			cen <= 1;
			if (count == 0) state <= descanso1;
			else count<= count-1;
			end // cierra escritura1
			
			descanso1: begin 
			mosii <= 0;
			count <= 7;
			scke <= 0;
			cen <= 1;
			if (count2 == 0) state <= escritura2;
			else count2<= count2-1;
			end // cierra el descanso 
			
			escritura2: begin 
			mosii <= data2[count];
			count2<= 1;
			count3<=1;
			scke <= 1;
			cen <= 1;
			if (count == 0) state <= descansob1;
			else count<= count-1;
			end // cierra escritura2
			
			descansob1:begin
			mosii <=  0;
			scke <= 0;
			if (count3 == 0) state <= descanso2;
			else count3<= count3-1;
			end // cierra el descanso2
			
			
			descanso2: begin 
			mosii <= 0;
			count <= 7;
			scke <= 0;
			cen <=1;
			if (count2 == 0) state <= escritura3;
			else count2<= count2-1;
			end // cierra el descanso2
			
			escritura3: begin 
			mosii <= data3[count];
			count2<= 1;
			scke <= 1;
			cen <=1;
			bspi <= 1;
			if (count == 0) state <= descanso3;
			else count<= count-1;
			end // cierra escritura2
			
			descanso3: begin 
			mosii <= 0;
			count <= 7;
			scke <= 0;
			cen <= 1;
			if (count2 == 0) state <= lectura1;
			else count2<= count2-1;
			end // cierra el descanso1
			
			lectura1: begin 
			mosii <= 0; 
			count2 <= 1;
			count3 <=1;
			scke <= 1;
			cen <= 1;
			datar1 <= {datar1[6:0], miso};//corriemiento y toma del miso
			BYTEL <= datar1;
			if (count == 0) state <= descansob2;
			else count<= count-1; 
			end // cierra escritura3
			
			descansob2:begin
			mosii <=  0;
			scke <= 0;
			if (count3 == 0) state <= descanso4;
			else count3<= count3-1;
			end // cierra el descanso2
			
		
			descanso4: begin 
			mosii <= 0;
			scke <= 0;
			cen <= 1;
			BYTEL <= datar1;
			count <= 7;
			count3 <= 1;
			if (count2 == 0) state <= escritura4;
			else count2<= count2-1;
			end // cierra el descanso2
			
			
			
			escritura4: begin 
			mosii <= data4[count]; 
			count2<= 1;
			scke <= 1;
			cen <= 1;
			if (count == 0) state <= descanso5;
			else count<= count-1;
			end // cierra escritura4
			
			
			
			descanso5: begin 
			mosii <= 0;
			scke <= 0;
			cen <= 1;
			BYTEM <= datar2;
			count <= 7;
			if (count2 == 0) state <= lectura2;
			else count2<= count2-1;
			end // cierra el descanso4
			
		   lectura2: begin 
			mosii <= 0; 
			count2 <= 1;
			count3 <= 1;
			scke <= 1;
			cen <= 1;
			datar2 <= {datar2[6:0],miso};
			BYTEM <= datar2;
			if (count == 0) state <= descansob3;
			else count<= count-1;
			end // cierra escritura4
			
			descansob3:begin
			mosii <=  0;
			scke <= 1;
			bspi <= 1;
			BYTEM <= datar2;
			if (count3 == 0) state <= descanso6;
			else count3<= count3-1;
			end // cierra el descanso2
			
			descanso6: begin 
			data1 <=CDIR1;//80
			data2 <=CDIR2;//E6
			data3 <=CDIR3;//01
			data4 <=CDIR4;//02
			mosii <= 0;
			scke <= 0;
			cen <= 0; 
			BYTEM <= datar2;
			count <= 7;
			count3 <= 3;
			bspi <= 0;
			if (count2 == 0) state <= escritura3;
			else count2<= count2-1;
			end // cierra el descanso4
			
			
			
			endcase 
		end
		end 
endmodule
