module dram_cell (
    input wire [7:0] data_in,
    input wire we,
    input wire reset,
    output reg [7:0] data_out
);
    
    always @(posedge we or posedge reset) begin
        if (reset) begin
            data_out <= 8'b0;
        end else begin
            data_out <= data_in;
        end
    end
endmodule