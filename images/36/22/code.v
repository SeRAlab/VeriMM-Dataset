module counter (
    input wire clk,
    input wire reset,
    output reg [2:0] state
);

    always @(posedge clk or posedge reset) begin
        if (reset) 
            state <= 3'b000; // Reset to 0
        else if (state < 3'b100) // Count up to 4 (0 to 3)
            state <= state + 1;
        else
            state <= 3'b000; // Reset to 0 after reaching 4
    end
endmodule