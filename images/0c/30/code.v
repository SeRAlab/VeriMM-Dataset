module ring_counter(
    input clk,
    input reset,
    input enable,
    output reg [4:0] count
);
    
    initial begin
        count = 5'b00001; // Initial state
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 5'b00001; // Reset to initial state
        end else if (enable) begin
            count <= {count[3:0], count[4]}; // Shift left
        end
    end
endmodule