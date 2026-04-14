module DVFS_Controller(
    input wire clk,
    input wire reset,
    input wire mode,
    output reg [1:0] voltage,    // 00 for 1V, 01 for 2V
    output reg [1:0] frequency    // 00 for 1GHz, 01 for 2GHz
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            voltage <= 2'b00;     // 1V
            frequency <= 2'b00;   // 1GHz
        end else begin
            case (mode)
                1'b0: begin
                    voltage <= 2'b00;     // 1V
                    frequency <= 2'b00;   // 1GHz
                end
                1'b1: begin
                    voltage <= 2'b01;     // 2V
                    frequency <= 2'b01;   // 2GHz
                end
            endcase
        end
    end
endmodule