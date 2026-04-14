module down_counter (
    input clk,
    input rst,
    input enable,
    output reg [3:0] count
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        count <= 4'b1111; // Reset to 15
    end else if (enable) begin
        if (count > 0) begin
            count <= count - 1;
        end
    end
end

endmodule