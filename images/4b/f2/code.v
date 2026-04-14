module top_module(clk, rst, request, acknowledge, grant, grant_valid, grant_encoded);input [3:0] acknowledge;
  input clk;
  output [3:0] grant;
  output [1:0] grant_encoded;
  output grant_valid;
  input [3:0] request;
  input rst;

  reg [3:0] grant_reg;
  reg [1:0] grant_encoded_reg;
  reg grant_valid_reg;

  always @(posedge clk) begin
    if (rst) begin
      grant_reg <= 4'b0000;
      grant_encoded_reg <= 2'b00;
      grant_valid_reg <= 1'b0;
    end else begin
      if (request[0] && !acknowledge[0]) begin
        grant_reg <= 4'b0001;
        grant_encoded_reg <= 2'b01;
        grant_valid_reg <= 1'b1;
      end else if (request[1] && !acknowledge[1]) begin
        grant_reg <= 4'b0010;
        grant_encoded_reg <= 2'b10;
        grant_valid_reg <= 1'b1;
      end else if (request[2] && !acknowledge[2]) begin
        grant_reg <= 4'b0100;
        grant_encoded_reg <= 2'b11;
        grant_valid_reg <= 1'b1;
      end else if (request[3] && !acknowledge[3]) begin
        grant_reg <= 4'b1000;
        grant_encoded_reg <= 2'b11;
        grant_valid_reg <= 1'b1;
      end else begin
        grant_reg <= 4'b0000;
        grant_encoded_reg <= 2'b00;
        grant_valid_reg <= 1'b0;
      end
    end
  end

  assign grant = grant_reg;
  assign grant_valid = grant_valid_reg;
  assign grant_encoded = grant_encoded_reg;

endmodule