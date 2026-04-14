module johnson_counter (
    input clk,
    input rst,
    output reg [4:0] q
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 5'b00000; // Reset state
        else
            q <= {q[3:0], ~q[4]}; // Johnson counter logic
    end
endmodule