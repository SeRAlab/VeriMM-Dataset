module top_module(
    input clk,
    input [3:0] D,
    input SI,
    output reg SO
);reg [3:0] reg_data;

    always @(posedge clk) begin
        if (SI) begin
            reg_data <= {reg_data[2:0], SI};
        end else begin
            reg_data <= D;
        end
    end

    assign SO = reg_data[0];

endmodule