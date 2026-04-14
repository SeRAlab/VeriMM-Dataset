module top_module(
             // inputs:
              address,
              begintransfer,
              clk,
              read,
              reset_n,
              write,
              writedata,

             // outputs:
              LCD_E,
              LCD_RS,
              LCD_RW,
              LCD_data,
              readdata
           )
;output           LCD_E;
  output           LCD_RS;
  output           LCD_RW;
  inout   [  7: 0] LCD_data;
  output  [  7: 0] readdata;
  input   [  1: 0] address;
  input            begintransfer;
  input            clk;
  input            read;
  input            reset_n;
  input            write;
  input   [  7: 0] writedata;

  wire             LCD_E;
  wire             LCD_RS;
  wire             LCD_RW;
  wire    [  7: 0] LCD_data;
  wire    [  7: 0] readdata;
  
  reg [7:0] data_reg;
  reg [1:0] state_reg;
  reg [1:0] next_state;
  reg        transfer_done;
  
  assign LCD_RW = address[0];
  assign LCD_RS = address[1];
  assign LCD_E = read | write;
  assign LCD_data = (address[0]) ? 8'bz : data_reg;
  assign readdata = (address[0]) ? 8'bz : LCD_data;
  
  always @(posedge clk) begin
    if (!reset_n) begin
      data_reg <= 8'b0;
      state_reg <= 2'b00;
      transfer_done <= 1'b0;
    end else if (begintransfer) begin
      state_reg <= next_state;
      transfer_done <= 1'b0;
    end else if (!transfer_done) begin
      case (state_reg)
        2'b00: begin // idle state
          next_state <= (read) ? 2'b10 : 2'b01;
        end
        2'b01: begin // write data state
          data_reg <= writedata;
          next_state <= 2'b00;
          transfer_done <= 1'b1;
        end
        2'b10: begin // read data state
          data_reg <= LCD_data;
          next_state <= 2'b00;
          transfer_done <= 1'b1;
        end
      endcase
    end
  end
  
endmodule