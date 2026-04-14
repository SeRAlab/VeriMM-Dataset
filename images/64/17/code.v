module counter_with_load
(
    input clk,
    input reset,
    input load,
    input [9:0] load_value,
    output reg [9:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 10'b0000000000; // Clear counter to 0
        end else if (load) begin
            count <= load_value; // Load value into counter
        end else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule