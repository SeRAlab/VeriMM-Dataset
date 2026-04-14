module top_module(
    input clk,
    input rst,
    input enable,
    input [3:0] voltage,
    input [3:0] ground,
    output reg [3:0] voltage_out,
    output reg [3:0] ground_out,
    output reg voltage_error,
    output reg ground_error
);reg [3:0] voltage_reg;
    reg [3:0] ground_reg;

    always @(posedge clk) begin
        if (rst) begin
            voltage_reg <= 0;
            ground_reg <= 0;
            voltage_error <= 0;
            ground_error <= 0;
        end else begin
            if (enable) begin
                if (voltage >= 0 && voltage <= 15) begin
                    voltage_reg <= voltage;
                    voltage_error <= 0;
                end else begin
                    voltage_reg <= 0;
                    voltage_error <= 1;
                end

                if (ground >= 0 && ground <= 15) begin
                    ground_reg <= ground;
                    ground_error <= 0;
                end else begin
                    ground_reg <= 0;
                    ground_error <= 1;
                end
            end else begin
                voltage_reg <= 0;
                ground_reg <= 0;
                voltage_error <= 0;
                ground_error <= 0;
            end
        end
    end

    assign voltage_out = voltage_reg;
    assign ground_out = ground_reg;

endmodule