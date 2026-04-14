module up_counter(
    input clk,
    input reset,
    output reg [3:0] count
);
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 4'b0000; // Reset the count to 0
        end else begin
            count <= (count == 4'b1111) ? 4'b0000 : count + 1; // Increment the count
        end
    end
endmodule