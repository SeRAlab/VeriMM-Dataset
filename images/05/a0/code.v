module flash_memory (
    input wire data_in,
    output reg data_out
);
    always @(*) begin
        data_out = data_in; // Simple storage of data
    end
endmodule