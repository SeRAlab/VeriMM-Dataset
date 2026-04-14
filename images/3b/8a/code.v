module deserializer (
    input wire clk,
    input wire reset,
    input wire [7:0] data_in,
    output reg [31:0] data_out,
    output reg done
);
    reg [2:0] count; // To count the number of 8-bit segments received

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 32'b0;
            count <= 3'b0;
            done <= 1'b0;
        end else if (count < 4) begin
            data_out <= {data_out[23:0], data_in}; // Shift in new data
            count <= count + 1;
            if (count == 3'b011) begin
                done <= 1'b1; // Indicate that 32 bits have been received
            end
        end
    end
endmodule