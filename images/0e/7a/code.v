module flash_memory (
    input clk,
    input enable,
    input read,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (!enable) begin
            // Erase operation
            memory <= 4'b0000;
        end else begin
            // Write operation
            memory <= data_in;
        end
    end

    always @(posedge clk) begin
        if (read) begin
            // Read operation
            data_out <= memory;
        end
    end
endmodule