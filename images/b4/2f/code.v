module johnson_counter(
    input clk,
    input reset,
    output reg [7:0] count
);

always @(posedge clk or posedge reset)
    if (reset) begin
        count <= 8'b00000000; // Reset counter to 0
    end else begin
        count <= {count[6:0], ~count[7]}; // Generate next state in Johnson sequence
    end

endmodule