module deserializer (
    input clk,
    input reset,
    input serial_in,
    output reg [31:0] parallel_out,
    output reg valid
);
    reg [4:0] count; // 5-bit counter for 32 bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            count <= 0;
            parallel_out <= 0;
            valid <= 0;
        end else begin
            if (count < 32) begin
                parallel_out <= {parallel_out[30:0], serial_in}; // Shift left and insert new bit
                count <= count + 1;
                if (count == 31) begin
                    valid <= 1; // Set valid when 32 bits have been received
                end
            end
        end
    end
endmodule