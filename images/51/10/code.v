module top_module(
    input A,
    input clk,            // Added clk input
    input [3:0] delay_val,
    output reg X
);reg [3:0] counter;

always @(posedge clk) begin
    if (counter == delay_val) begin
        X <= A;
        counter <= 0;     // Reset counter when delay is reached
    end else begin
        counter <= counter + 1;  // Increment counter
    end
end

endmodule