module top_module(
    input clk,
    input reset,
    input [7:0] timecode_data,
    input timecode_valid,
    input [12:0] timecode_address,
    output reg [7:0] data_out,
    output reg write_enable
);// Internal signals
    reg [7:0] memory_data;
    reg [12:0] memory_address;
    reg memory_write_enable;

    always @(posedge clk) begin
        if (reset) begin
            // Reset internal signals
            memory_data <= 8'h00;
            memory_address <= 13'h000;
            memory_write_enable <= 1'b0;
            data_out <= 8'h00;
            write_enable <= 1'b0;
        end else begin
            if (timecode_valid) begin
                // Write timecode data to memory
                memory_data <= timecode_data;
                memory_address <= timecode_address;
                memory_write_enable <= 1'b1;
            end else begin
                // Read data from memory
                memory_address <= timecode_address;
                memory_write_enable <= 1'b0;
                data_out <= memory_data;
                write_enable <= memory_write_enable;
            end
        end
    end

endmodule