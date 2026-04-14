module up_down_counter (
    input clk,
    input reset,
    input up_down, // 1 for up, 0 for down
    output reg [3:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // reset count to zero
        end else if (up_down) begin
            count <= count + 1; // increment count
        end else begin
            count <= count - 1; // decrement count
        end
    end
endmodule