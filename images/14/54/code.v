module divide_by_2 (
    input clk,
    input reset,
    input in,
    output reg out
);
    reg [1:0] state;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= 2'b00;
            out <= 1'b0;
        end else begin
            state <= {state[0], in}; // Shift in the new bit
            out <= state[1]; // The output is the second bit of the state
        end
    end
endmodule