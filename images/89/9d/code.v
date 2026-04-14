module top_module(
  input Reset_n_i,
  input Clk_i,
  input SPI_FSM_Start,
  input SPI_Transmission_i,
  input [7:0] SPI_Data_i,
  output reg [7:0] Byte0,
  output reg [7:0] Byte1,
  output reg MAX6682CS_n_o,
  output reg SPI_Write_o,
  output reg SPI_ReadNext_o,
  output reg SPI_FSM_Done
);reg [2:0] SPI_FSM_State;

  always @(posedge Clk_i or negedge Reset_n_i) begin
    if (!Reset_n_i) begin
      SPI_FSM_State <= 3'b000;
      Byte0 <= 8'b0;
      Byte1 <= 8'b0;
      MAX6682CS_n_o <= 1'b1;
      SPI_Write_o <= 1'b0;
      SPI_ReadNext_o <= 1'b0;
      SPI_FSM_Done <= 1'b0;
    end else begin
      case (SPI_FSM_State)
        3'b000: begin
          MAX6682CS_n_o <= 1'b0;
          SPI_FSM_State <= 3'b001;
          SPI_Write_o <= 1'b1;
        end
        3'b001: begin
          SPI_FSM_State <= 3'b010;
          SPI_Write_o <= 1'b0;
        end
        3'b010: begin
          if (SPI_Transmission_i) begin
            SPI_FSM_State <= 3'b011;
            SPI_Write_o <= 1'b1;
          end else begin
            SPI_FSM_State <= 3'b100;
            SPI_ReadNext_o <= 1'b1;
          end
        end
        3'b011: begin
          SPI_FSM_State <= 3'b010;
          SPI_Write_o <= 1'b0;
        end
        3'b100: begin
          Byte0 <= SPI_Data_i;
          SPI_FSM_State <= 3'b101;
          SPI_ReadNext_o <= 1'b1;
        end
        3'b101: begin
          Byte1 <= SPI_Data_i;
          SPI_FSM_State <= 3'b110;
          SPI_ReadNext_o <= 1'b0;
          MAX6682CS_n_o <= 1'b1;
          SPI_FSM_Done <= 1'b1;
        end
        3'b110: begin
          SPI_FSM_State <= 3'b000;
          Byte0 <= 8'b0;
          Byte1 <= 8'b0;
          MAX6682CS_n_o <= 1'b1;
          SPI_Write_o <= 1'b0;
          SPI_ReadNext_o <= 1'b0;
          SPI_FSM_Done <= 1'b0;
        end
      endcase
    end
  end

endmodule