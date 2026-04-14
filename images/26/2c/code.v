module Counter (
    input clk,
    input rst,
    output reg [1:0] state
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00; // reset state
        end else begin
            state <= state + 1; // count up
        end
    end
endmodule