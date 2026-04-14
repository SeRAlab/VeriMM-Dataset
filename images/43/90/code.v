module geq_8_check_module(
    input wire clk,
    input wire reset,
    input wire [3:0] binary_num,
    output reg is_geq_8
);

    always @(posedge clk) begin
        if (reset) begin
            is_geq_8 <= 0;
        end else begin
            if (binary_num >= 8) begin
                is_geq_8 <= 1;
            end else begin
                is_geq_8 <= 0;
            end
        end
    end

endmodule