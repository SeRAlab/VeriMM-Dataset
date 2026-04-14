module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b0; // Reset count to 0
        end else if (enable) begin
            count <= count + 1; // Increment count
        end
    end
endmodule