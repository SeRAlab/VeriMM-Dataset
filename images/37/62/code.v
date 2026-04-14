module dram_cell (
    input wire write_enable,
    input wire data_in,
    input wire refresh,
    output reg data_out,
    output reg valid
);

always @(posedge refresh or posedge write_enable) begin
    if (write_enable) begin
        data_out <= data_in;
        valid <= 1'b1;
    end
    else if (refresh) begin
        valid <= 1'b1; // refresh signal, keep valid
    end
end

endmodule