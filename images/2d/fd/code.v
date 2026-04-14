module dram_cell (
    input wire [7:0] data_in,
    input wire WE,
    input wire RE,
    input wire RST,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge RST or posedge WE or posedge RE) begin
        if (RST) begin
            memory <= 8'b0;
            data_out <= 8'b0;
        end else if (WE) begin
            memory <= data_in;
        end else if (RE) begin
            data_out <= memory;
        end
    end
endmodule