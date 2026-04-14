module divide_by_2(
    input clk,
    input rst,
    input in,
    output reg out
);
    reg [1:0] state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= 2'b00;
            out <= 1'b0;
        end else begin
            state <= {state[0], in};
            out <= state[1];
        end
    end
endmodule