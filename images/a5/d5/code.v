module top_module(
    input [3:0] data_in,
    input [1:0] control,
    output [3:0] data_out
);reg [3:0] temp;

    always @(*) begin
        case (control)
            2'b00: temp = {data_in[2:0], 1'b0};
            2'b01: temp = {1'b0, data_in[3:1]};
            2'b10: temp = {data_in[2:0], data_in[3]};
            2'b11: temp = {data_in[3], data_in[3:1]};
        endcase
    end

    assign data_out = temp;

endmodule