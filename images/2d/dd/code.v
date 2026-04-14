module timer (
    input clk,
    input rst,
    input [7:0] start_val,
    output reg [7:0] current_val
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        current_val <= 8'b0;
    end else if (current_val > 0) begin
        current_val <= current_val - 1;
    end else begin
        current_val <= current_val; // Remain at zero
    end
end

always @(posedge clk) begin
    if (current_val == 0) begin
        current_val <= current_val; // Hold at zero
    end
end

endmodule