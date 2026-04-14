module top_module(input [7:0] data, output reg out_bit_def, out_bit_ovr);reg [3:0] ones_count;

always @(*) begin
    ones_count = {data[7], data[6], data[5], data[4], data[3], data[2], data[1], data[0]};
end

always @(*) begin
    if(ones_count >= 4) begin
        out_bit_def = 1'b1;
    end else begin
        out_bit_def = 1'b0;
    end

    if(data[4] == 1'b1) begin
        out_bit_ovr = 1'b1;
    end else begin
        out_bit_ovr = 1'b0;
    end
end

endmodule