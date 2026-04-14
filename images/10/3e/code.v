module down_counter(
    input wire clk,
    input wire rst,
    input wire [3:0] init_value,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= init_value; // Load initial value on reset
        end else begin
            if (count == 0)
                count <= 4'b1111; // Wrap around to 15
            else
                count <= count - 1; // Decrement the counter
        end
    end
endmodule