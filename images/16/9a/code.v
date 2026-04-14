module flash_memory (
    input wire clk,
    input wire write_enable,
    input wire [4:0] data_in,
    output reg [4:0] data_out
);
    
    always @(posedge clk) begin
        if (write_enable) begin
            data_out <= data_in;
        end
    end
endmodule