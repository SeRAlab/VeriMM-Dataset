module down_counter (
    input clk,
    input reset,
    input enable,
    input [n-1:0] initial_value,
    output reg [n-1:0] count
);
    parameter n = 4; // Set the width of the counter to 4 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= initial_value;
        end else if (enable) begin
            if (count > 0)
                count <= count - 1;
        end
    end
endmodule