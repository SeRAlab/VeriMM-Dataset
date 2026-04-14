module timer_8bit (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] count
);
    always @(posedge clk or posedge reset) begin
        if (reset) 
            count <= 8'b0;  // Reset the count to 0
        else if (enable) 
            count <= (count == 8'b11111111) ? 8'b0 : count + 1; // Increment or roll over
    end
endmodule