module counter(
    input clk,
    input reset,
    input up_down, // 1 for up, 0 for down
    input load,
    input [15:0] load_value,
    output reg [15:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 16'b0; // Reset the counter
        end else if (load) begin
            count <= load_value; // Load the specified value
        end else begin
            if (up_down) begin
                count <= count + 1; // Increment
            end else begin
                count <= count - 1; // Decrement
            end
        end
    end
endmodule