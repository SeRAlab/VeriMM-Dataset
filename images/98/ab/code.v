module top_module(
    input [7:0] data_in,
    input [1:0] control_in,
    output reg [7:0] data_out
);always @(*) begin
        case (control_in)
            2'b00: data_out = data_in;
            2'b01: data_out = ~data_in;
            2'b10: data_out = {data_in[6:0], 1'b0};
            2'b11: data_out = {1'b0, data_in[7:1]};
            default: data_out = 8'b0;
        endcase
    end

endmodule