module up_counter
(
    input clk,
    input reset,
    input load,
    input [5:0] load_value,
    output reg [5:0] count
);
    always @(posedge clk) begin
        if (reset) begin
            count <= 6'b000000; // Set counter to 0
        end else if (load) begin
            count <= load_value; // Load value into counter
        end else begin
            count <= count + 1; // Increment counter
        end
    end

endmodule