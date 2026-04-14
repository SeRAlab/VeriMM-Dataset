module top_module(
    input clk,
    input reset,
    input [15:0] data_in,
    output reg [3:0] data_out
);always @(posedge clk) begin
    if (reset) begin
        data_out <= 0;
    end else begin
        case (data_in[15:12])
            4'b0000: data_out <= 4'b0000;
            4'b1111: data_out <= 4'b1111;
            default: data_out <= data_in[15:12] + data_in[3:0];
        endcase
    end
end

endmodule