module parity_generator_checker (
    input clk,
    input reset,
    input [9:0] data,
    output reg parity
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            parity <= 1'b0;
        end else begin
            parity <= ^data;
        end
    end

endmodule