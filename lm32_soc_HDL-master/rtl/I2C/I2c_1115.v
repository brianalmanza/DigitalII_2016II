`timescale 1ns / 10ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Universidad Nacional de Colombia
// Engineer: Leonardo Sarmiento
//
// Create Date:    23:28:10 06/11/2016
// Design Name:	 I2C_Ads-1115
// Module Name:    I2c_1115
// Project Name:
// Target Devices:
// Tool versions:
// Description:
//
// Dependencies:
// Revision 0.01 - File Created
// Additional Comments:
//
//////////////////////////////////////////////////////////////////////////////////
//`default_nettype none

module I2c_1115(
    input wire clk,
    input wire reset,
    inout wire Sda,
    output Scl,
    output wire busy,
    input wire [7:0] CAM,
    input wire [7:0] CAL,
    input wire [7:0] AD1,
    input wire [7:0] AD2,
    input wire [7:0] AD3,
    input wire [7:0] writei2c,
    input wire [7:0] stopi2c,
    output reg [7:0] A0M,
    output reg [7:0] A0L
    );
	 
localparam state0 = 0;
localparam state1 = 1;
localparam state2 = 2;    
    
localparam estado0 = 1;
localparam estadoi = 0;
localparam estado1 = 2;
localparam estado2 = 3;

localparam estlec11 = 0;
localparam estlec12 = 1;


localparam STATE_IDLE = 0;
localparam STATE_PRESTART = 1;
localparam STATE_START = 2;
localparam STATE_ADDR = 3;
localparam STATE_RW = 4;
localparam STATE_WACK = 5;
localparam STATE_REST = 6;
localparam STATE_DATA = 7;
localparam STATE_WACK2 = 8;
localparam STATE_REST2 = 9;
localparam STATE_DATA2 = 10;
localparam STATE_WACK3 = 11;
localparam STATE_REST3 = 12;
localparam STATE_DATA3 = 13;
localparam STATE_WACK4 = 14;
localparam STATE_REST4 = 15;
localparam STATE_POSTSTART = 16;
localparam STATE_STOP = 17;
localparam STATE_PRERESTART = 18;
localparam STATE_RESTART = 19;
localparam STATE_ADDR2 = 20;
localparam STATE_RW2 = 21;
localparam STATE_WACK5 = 22;
localparam STATE_REST5 = 23;
localparam STATE_DATA4 = 24;
localparam STATE_WACK6 = 25;
localparam STATE_REST6 = 26;
localparam STATE_POSTRESTART = 27;
localparam STATE_STOP2 = 28;
localparam STATE_PRERESTART2 = 29;
localparam STATE_RESTART2 = 30;
localparam STATE_ADDR3 = 31;
localparam STATE_RW3 = 32;
localparam STATE_WACK7 = 33;
localparam STATE_REST7 = 34;
localparam STATE_DATA5 = 35;
localparam STATE_WACK8 = 36;
localparam STATE_REST8 = 37;
localparam STATE_DATA6 = 38;
localparam STATE_WACK9 = 39;
localparam STATE_REST9 = 40;
localparam STATE_POSTRESTART2 = 41;
localparam STATE_STOP3 = 42;
localparam STATE_DONE = 43;
localparam STATE_DEFAULT = 44;
localparam STATE_DEFAULT2 = 45;
localparam STATE_DEFAULT3 = 46;

reg [7:0] state;
reg [6:0] addr;
reg [7:0] count;
reg [7:0] count2;
reg [7:0] count3;
reg [7:0] data;
reg [7:0] data2;
reg [7:0] data3;
reg [7:0] data4;
reg [7:0] data5;
reg [7:0] data6;

reg [7:0] datar = 0;
reg [7:0] datar2 = 0;

reg i2c_scl_enable;
reg sda1;
reg sda2;
reg ocu;


reg busy2 = 0;
reg [31:0] cont1 = 0;
reg [9:0] cont2 = 0;
reg [9:0] cont3 = 0;
reg div1;
reg div2;
reg div3;

reg i2cscl;
reg i2c_scl;
reg w_i2c;
reg s_i2c;

reg [4:0] est;
reg [9:0] cone;
reg [9:0] cone2;
reg [9:0] cone3;
reg [1:0] estlec;

reg [9:0] stat;
reg [9:0] contz;

reg i2ce;
reg sdae;

wire read_sda = Sda;
assign Sda = (sda1 == 1) ? 1'bz : 0;
assign Scl = (i2c_scl == 1) ? 1'bz : 0;
assign busy = busy2;

always @(posedge clk) begin//Divisor 1Mhz
        if (reset == 1) begin
        div1 = 0;
        cont1 = 0;
        end
        else begin
        
        if (cont1 == 25) begin
            div1 = ~div1;
            cont1 = 0;
        end
        else begin
        cont1 = cont1 + 1;
        end
    end
 end    
 
always @(negedge div1) begin//Divisor 100khz
        if ((reset == 1)) begin
        div2 = 0;
        cont2 = 0;
        end
        else begin
        
        if (cont2 == 9) begin
            div2 = ~div2;
            cont2 = 0;
        end
        else begin
        cont2 = cont2 + 1;
        end
    end
 end    



        
always @(posedge (i2cscl),negedge (i2cscl),posedge(i2c_scl_enable),posedge(i2ce)) begin // scl final
         if(i2c_scl_enable == 0) begin
         i2c_scl <= 0;
         end
         else begin
          if(i2ce == 0) begin
          i2c_scl <= 1;
          end
          else begin
          if((i2ce == 1)||(i2c_scl_enable == 1)) begin
         i2c_scl <= i2cscl;
         end
        end
       end
    end    

always @(negedge div1) begin //maquina de estados scl
        if (reset == 1) begin
            est <= 0;
            i2cscl <= 1;
        end
        else begin
        
        case(est)
            estadoi: begin
            cone <= 3;
            i2cscl <= 0;
            est <= estado0;
           end
            
        estado0: begin
            i2cscl <= 0;
            if (cone == 0) begin
            est <= estado1;
            cone2 <= 8;
            end else begin
            cone <= cone - 1;
            end
        end
        
        estado1: begin
            i2cscl <= 1;
            cone3 <= 5;
            if (cone2 == 0) est <= estado2;
            else cone2 <= cone2 - 1;
            end
                
        estado2: begin
            i2cscl <= 0;
            if (cone3 == 0) est <= estadoi;
            else cone3 <= cone3 - 1;
            end

    endcase
 end
end    
        
        
    always@(negedge div2) begin
        if (reset == 1) begin
        i2ce <= 0;
        end else begin
        if ((state == STATE_IDLE) || (state == STATE_START) || (state == STATE_STOP)|| (state == STATE_RESTART) || (state == STATE_STOP2)|| (state == STATE_RESTART2) || (state == STATE_STOP3)|| (state == STATE_PRESTART)|| (state == STATE_PRERESTART)|| (state == STATE_PRERESTART2)|| (state == STATE_POSTSTART)|| (state == STATE_POSTRESTART)|| (state == STATE_POSTRESTART2)|| (state == STATE_DONE)|| (state == STATE_DEFAULT)|| (state == STATE_DEFAULT2)|| (state == STATE_DEFAULT3)) begin
        i2ce <= 0;
        end
        else begin
        i2ce <= 1;
        end
    end
end
     
    always @(negedge(div2)) begin  // maquina de estados del sda
        if((reset == 1)) begin
            state <= STATE_DEFAULT;
            sda1 <= 1;
            addr <=  AD1[6:0];
	    busy2 <= 0;
            data <=  AD2;
            data2 <= CAM;
            data3 <= CAL;
            data4 <= AD3;
            data5 <= 8'hff;
            data6 <= 8'hff;
            count2 <= 0;
            count <= 5;
	    w_i2c <= writei2c[0];
	    s_i2c <= stopi2c[0];			
        end
        else begin
        
    case(state)

    STATE_DEFAULT: begin//idle
        sda1 <= 1;
        data2 <= CAM;
        data3 <= CAL;
        addr <=  AD1[6:0];
        data <=  AD2;
        data4 <= AD3;
	w_i2c <= writei2c[0];
	s_i2c <= stopi2c[0];
	busy2 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_DEFAULT2;
    end
    
     STATE_DEFAULT2: begin // Prestart
        sda1 <= 1;
	busy2 <= 1;
        i2c_scl_enable <= 1;
        if (w_i2c == 1) state <= STATE_DEFAULT3;
        else state <= STATE_DEFAULT2;
    end

     STATE_DEFAULT3: begin // Prestart
        sda1 <= 1;
	busy2 <= 1;
        i2c_scl_enable <= 1;
        if (s_i2c == 0) state <= STATE_IDLE;
        else state <= STATE_DEFAULT3;
    end

    STATE_IDLE: begin//idle
        sda1 <= 1;
	busy2 <= 1;
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_PRESTART;
        else count <= count - 1;
    
    end
    
     STATE_PRESTART: begin // Prestart
        sda1 <= 0;
	busy2 <= 1;
        state <= STATE_START;
        i2c_scl_enable <= 1;
    end
    
    STATE_START: begin // start
        sda1 <= 0;
        state <= STATE_ADDR;
        i2c_scl_enable <= 0;
        count <= 6;
    end
    
    STATE_ADDR: begin // msb adress bit
        sda1 <= addr[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_RW;
        else count <= count - 1;
    
    end
    
    STATE_RW: begin //
        sda1 <= 0;
        i2c_scl_enable <= 1;
        state <= STATE_WACK;
        end
        
    STATE_WACK: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST;
        count <= 7;
        count2 <= 0;
        end
        
        STATE_REST: begin // start
        sda1 <= 1;
        i2c_scl_enable <= 0;
        if (count2 == 0) state <= STATE_DATA;
        else count2 <= count2 - 1;
    end
    
    STATE_DATA: begin
        sda1 <= data[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_WACK2;
        else count <= count - 1;
        end
        
    STATE_WACK2: begin
       sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST2;
        count <= 7;
        end
    
        STATE_REST2: begin // start
        sda1 <= 1;
        i2c_scl_enable <= 0;
        state <= STATE_DATA2;
    end
    
    STATE_DATA2: begin
        sda1 <= data2[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_WACK3;
        else count <= count - 1;
        end
        
    STATE_WACK3: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST3;
        count <= 7;
        end
    
        STATE_REST3: begin // start
        sda1 <= 1;
        i2c_scl_enable <= 0;
	state <= STATE_DATA3;
    end
    
    STATE_DATA3: begin
        sda1 <= data3[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_WACK4;
        else count <= count - 1;
        end    
        
    STATE_WACK4: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST4;
        count <= 3;
        end
        
        STATE_REST4: begin // start
        sda1 <= 1;
        i2c_scl_enable <= 0;
        state <= STATE_POSTSTART;
    end
        
   STATE_POSTSTART: begin // PreREstart
        sda1 <= 0;
       i2c_scl_enable <= 1;
        state <= STATE_STOP;
    end    
                
    STATE_STOP: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_PRERESTART;
        else count <= count - 1;
        end  
          
     STATE_PRERESTART: begin // PreREstart
        sda1 <= 0;
        state <= STATE_RESTART;
        i2c_scl_enable <= 1;
    end          
    
    STATE_RESTART: begin // start
        sda1 <= 0;
        i2c_scl_enable <= 0;
        state <= STATE_ADDR2;
        count <= 6;
    end
    
    STATE_ADDR2: begin // msb adress bit
        sda1 <= addr[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_RW2;
        else count <= count - 1;
    end
    
    STATE_RW2: begin //
        sda1 <= 0;
        i2c_scl_enable <= 1;
        state <= STATE_WACK5;
        end     
        
    STATE_WACK5: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST5;
        count <= 7;
        end
    
    STATE_REST5: begin // start
        sda1 <= 1;
        i2c_scl_enable <= 0;
        state <= STATE_DATA4;
    end
    
    STATE_DATA4: begin
        sda1 <= data4[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_WACK6;
        else count <= count - 1;
        end    
        
    STATE_WACK6: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST6;
        count <= 3;
        end
        
    STATE_REST6: begin // start
        sda1 <= 1;
        i2c_scl_enable <= 0;
        state <= STATE_POSTRESTART;
    end  

        STATE_POSTRESTART: begin // PreREstart
        sda1 <= 0;
       i2c_scl_enable <= 1;
        state <= STATE_STOP2;
    end
    
    STATE_STOP2: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_PRERESTART2;
        else count <= count - 1;
        end  
          
    STATE_PRERESTART2: begin // Prestart
        sda1 <= 0;
        state <= STATE_RESTART2;
        i2c_scl_enable <= 1;
    end
        
    STATE_RESTART2: begin // start
        sda1 <= 0;
        i2c_scl_enable <= 0;
        state <= STATE_ADDR3;
        count <= 6;
    end     
    
    STATE_ADDR3: begin // msb adress bit
        sda1 <= addr[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_RW3;
        else count <= count - 1;
    end    
    
    STATE_RW3: begin //
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_WACK7;
        count <= 7;
        end
        
    STATE_WACK7: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_REST7;
        count <= 7;
       count2 <= 0;
       A0M <= datar;
        end
        
                
        STATE_REST7: begin // start
        sda1 <= 1;
        A0M <= datar;
        i2c_scl_enable <= 0;
        if (count2 == 0) state <= STATE_DATA5;
        else count2 <= count2 - 1;
    end

     

    STATE_DATA5: begin
          datar <= {datar[6:0], read_sda};
          A0M <= datar;
          sda1 <= data5[count];
        i2c_scl_enable <= 1;
        if (count == 0) begin
          state <= STATE_WACK8;
          end
          else begin
        count <= count - 1;
        end
         end
        
    STATE_WACK8: begin
        sda1 <= 0;
        A0M <= datar;
        i2c_scl_enable <= 1;
        state <= STATE_REST8;
        count <= 7;
        count2 <= 0;
        end
        
   STATE_REST8: begin // start
        sda1 <= 1;
        A0M <= datar;
        A0L <= datar2;
        i2c_scl_enable <= 0;
        if (count2 == 0) state <= STATE_DATA6;
        else count2 <= count2 - 1;
    end
    
    STATE_DATA6: begin
        datar2 <= {datar2[6:0], read_sda};
        A0L <= datar2;
        sda1 <= data6[count];
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_WACK9;
        else count <= count - 1;
        end
        

    STATE_WACK9: begin
        A0L <= datar2;
        sda1 <= 0;
        i2c_scl_enable <= 1;
        state <= STATE_REST9;
        count <= 5;
        end

        STATE_REST9: begin // start
        sda1 <= 1;
        A0L <= datar2;
        i2c_scl_enable <= 0;
        state <= STATE_POSTRESTART2;
    end  

        STATE_POSTRESTART2: begin // PreREstart
        sda1 <= 0;
	busy2 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_STOP3;
    end

    STATE_STOP3: begin
        sda1 <= 1;
        i2c_scl_enable <= 1;
        state <= STATE_DONE;
        end
		  
    STATE_DONE: begin // PreREstart
        sda1 <= 1;
	busy2 <= 0;
        //ready <= 1;
        i2c_scl_enable <= 1;
        if (count == 0) state <= STATE_DEFAULT;
        else count <= count - 1;
    end

        
    endcase
    end
    end    
        
          
endmodule




