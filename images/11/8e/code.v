module dma_controller (
    input wire clk,
    input wire reset,
    input wire start_chan1,
    input wire start_chan2,
    input wire [7:0] data_in_chan1,
    input wire [7:0] data_in_chan2,
    output reg [7:0] data_out_chan1,
    output reg [7:0] data_out_chan2,
    output reg busy_chan1,
    output reg busy_chan2
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out_chan1 <= 8'b0;
            data_out_chan2 <= 8'b0;
            busy_chan1 <= 1'b0;
            busy_chan2 <= 1'b0;
        end else begin
            if (start_chan1 && !busy_chan1) begin
                data_out_chan1 <= data_in_chan1;
                busy_chan1 <= 1'b1;
            end else if (busy_chan1) begin
                busy_chan1 <= 1'b0;
            end
            
            if (start_chan2 && !busy_chan2) begin
                data_out_chan2 <= data_in_chan2;
                busy_chan2 <= 1'b1;
            end else if (busy_chan2) begin
                busy_chan2 <= 1'b0;
            end
        end
    end
endmodule