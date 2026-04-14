module johnson_counter (
    input clk,
    input rst,
    output reg [4:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= 5'b00000;
        end else begin
            q <= {q[3:0], ~q[4]};
        end
    end
endmodule