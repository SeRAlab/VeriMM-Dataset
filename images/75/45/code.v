module top_module(
    input clk,
    input reset,
    input [7:0] data_in,
    input valid_in,
    output reg ready_out,
    output reg [9:0] accu_out
);reg [7:0] parity_bit;
reg [9:0] accumulator;

always @(posedge clk) begin
    if (reset) begin
        parity_bit <= 1'b0;
        accumulator <= 10'b0;
        ready_out <= 1'b0;
    end else begin
        if (valid_in) begin
            parity_bit <= ^data_in;
            accumulator <= accumulator + {1'b0, parity_bit};
            ready_out <= 1'b1;
        end else begin
            ready_out <= 1'b0;
        end
    end
end

assign accu_out = ready_out ? accumulator : {1'b0, parity_bit};

endmodule