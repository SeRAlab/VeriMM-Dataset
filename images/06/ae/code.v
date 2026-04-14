module counter_2bit (
    input wire clk,
    input wire reset,
    input wire up,
    input wire down,
    output reg [1:0] count
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        count <= 2'b00; // Initialize counter to 00
    end else if (up && !down) begin
        count <= count + 1; // Count up
    end else if (down && !up) begin
        count <= count - 1; // Count down
    end
end

endmodule