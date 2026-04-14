module top_module(
  input clk,
  input [7:0] data_in,
  input [3:0] control,
  input rst_n,
  output [7:0] data_out,
  output [3:0] status
);reg [7:0] data_out_reg;
  reg [3:0] status_reg;

  always @(posedge clk) begin
    if (!rst_n) begin
      data_out_reg <= 8'h00;
      status_reg <= 4'h0;
    end else begin
      case (control)
        4'h0: begin
          data_out_reg <= {data_in[6:0], 1'b0};
          status_reg <= 4'h1;
        end
        4'h1: begin
          data_out_reg <= {1'b0, data_in[7:1]};
          status_reg <= 4'h2;
        end
        4'h2: begin
          data_out_reg <= ~data_in;
          status_reg <= 4'h3;
        end
        4'h3: begin
          data_out_reg <= 8'hFF;
          status_reg <= 4'h4;
        end
        default: begin
          data_out_reg <= 8'h00;
          status_reg <= 4'h0;
        end
      endcase
    end
  end

  assign data_out = data_out_reg;
  assign status = status_reg;

endmodule