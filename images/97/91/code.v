module top_module(
    input [3:0] data,
    input rotate,
    output reg [3:0] shifted_data
);always @(*) begin
        if (rotate) begin
            shifted_data[0] = data[3];
            shifted_data[1] = data[0];
            shifted_data[2] = data[1];
            shifted_data[3] = data[2];
        end else begin
            shifted_data[0] = data[1];
            shifted_data[1] = data[2];
            shifted_data[2] = data[3];
            shifted_data[3] = 0;
        end
    end

endmodule