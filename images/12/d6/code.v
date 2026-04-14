module serializer_32bit (
    input wire clk,
    input wire enable,
    input wire [31:0] data_in,
    output reg serial_out,
    output reg done
);
    reg [5:0] count; // to keep track of the bits serialized

    always @(posedge clk) begin
        if (enable) begin
            if (count < 32) begin
                serial_out <= data_in[31 - count]; // serialize the bits
                count <= count + 1;
                done <= 0;
            end else begin
                done <= 1; // signal that serialization is done
            end
        end else begin
            count <= 0; // reset when not enabled
            serial_out <= 0;
            done <= 0;
        end
    end

    initial begin
        count = 0;
        serial_out = 0;
        done = 0;
    end
endmodule