module down_counter(
    input clk,
    input rst,
    input enable,
    input [3:0] load_value,
    output reg [3:0] count
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 4'b0000;
        end else if (enable) begin
            if (count > 0) begin
                count <= count - 1;
            end else begin
                count <= 4'b0000; // Ensure it stays at 0
            end
        end else begin
            count <= count; // Hold the value
        end
    end

    always @(negedge clk) begin
        if (enable && count == 0) begin
            count <= load_value;
        end
    end
endmodule