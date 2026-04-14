module up_down_counter (
    input clk,
    input reset,
    input up_down, // control signal: 1 for counting up, 0 for counting down
    output reg [7:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 8'b0; // reset to 0
    end else begin
        if (up_down) begin
            count <= count + 1; // count up
        end else begin
            count <= count - 1; // count down
        end
    end
end

endmodule