module timer (
    input wire clk,
    input wire reset,
    input wire enable,
    output reg [7:0] count
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 8'b00000000; // Reset the count to 0
        end else if (enable) begin
            count <= count + 1; // Increment the count
            if (count == 8'b11111111) begin
                count <= 8'b00000000; // Wrap around to 0
            end
        end
    end
endmodule