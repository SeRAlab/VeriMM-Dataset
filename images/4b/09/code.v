module top_module(clk, data_in, shamt, fnc, data_out);input clk;
    input [31:0] data_in;
    input [4:0] shamt;
    input [1:0] fnc;
    output reg [31:0] data_out;

  always @(posedge clk) begin
    if (fnc == 2'b00) begin
      
      data_out <= data_in << shamt;
    end else
    if (fnc == 2'b01) begin
      
      data_out <= data_in >> shamt;
    end else
    if (fnc == 2'b10) begin
      
      if (data_in[31] == 1) begin
        data_out <= ~(32'hFFFFFFFF >> shamt) |
                    (data_in >> shamt);
      end else begin
        data_out <= data_in >> shamt;
      end
    end else begin
      data_out <= 32'hxxxxxxxx;
    end
  end

endmodule