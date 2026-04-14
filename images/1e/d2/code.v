module deserializer (
    input wire clk,
    input wire reset,
    input wire [1:0] data_in,
    output reg [15:0] data_out,
    output reg valid
);
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 16'b0;
            count <= 4'b0;
            valid <= 1'b0;
        end else begin
            if (count < 8) begin
                data_out <= {data_out[13:0], data_in}; // Shift in the new data
                count <= count + 1;
            end
            if (count == 7) begin
                valid <= 1'b1; // Set valid after 8 cycles
            end
            if (count == 8) begin
                count <= 4'b0; // Reset count after 8 cycles
                valid <= 1'b0; // Reset valid signal
            end
        end
    end
endmodule