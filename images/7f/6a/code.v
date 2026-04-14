module loadable_counter
(
    input clk,
    input reset,
    input enable,
    input load,
    input [7:0] data_in,
    output reg [7:0] count
);

    always @(posedge clk) begin
        if (reset) begin
            count <= 8'b00000000; // Reset counter to 00000000
        end else if (load) begin
            count <= data_in; // Load input value
        end else if (enable) begin
            count <= count + 1; // Increment counter
        end
    end

endmodule