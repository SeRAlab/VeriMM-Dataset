module shift_register (
    input wire clk,
    input wire enable,
    input wire load,
    input wire direction, // 1 for left shift, 0 for right shift
    input wire [7:0] data_in,
    output reg [7:0] data_out
);

    always @(posedge clk) begin
        if (load) begin
            data_out <= data_in;
        end else if (enable) begin
            if (direction) begin
                data_out <= {data_out[6:0], 1'b0}; // Shift left
            end else begin
                data_out <= {1'b0, data_out[7:1]}; // Shift right
            end
        end
    end
endmodule