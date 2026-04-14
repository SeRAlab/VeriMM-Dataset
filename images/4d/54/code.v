module top_module(
    input clk,
    input [15:0] data_in,
    input [1:0] control,
    output reg [15:0] data_out
);always @(posedge clk) begin
    case (control)
        2'b00: data_out <= data_in;
        2'b01: data_out <= ~data_in;
        2'b10: data_out <= {data_in[14:0], 1'b0};
        2'b11: data_out <= {1'b0, data_in[15:1]};
    endcase
end

endmodule