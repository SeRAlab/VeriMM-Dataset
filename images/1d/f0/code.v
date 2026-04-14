module dma_controller (
    input wire clk,
    input wire reset,
    input wire chan1_en,
    input wire chan2_en,
    input wire [7:0] chan1_addr,
    input wire [7:0] chan2_addr,
    output reg [7:0] data_out,
    output reg done
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
            done <= 1'b0;
        end else begin
            if (chan1_en) begin
                data_out <= chan1_addr; // Simulate data transfer
                done <= 1'b1;
            end else if (chan2_en) begin
                data_out <= chan2_addr; // Simulate data transfer
                done <= 1'b1;
            end else begin
                done <= 1'b0;
            end
        end
    end
endmodule