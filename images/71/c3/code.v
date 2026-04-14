module shift_register_8bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [7:0] data_in,
    input wire shift_in,
    output wire [7:0] data_out
);

    wire [3:0] data_out_0, data_out_1;

    shift_register_4bit shift_register_4bit_inst1 (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in[7:4]),
        .shift_in(data_out_0[0]),
        .data_out(data_out[7:4])
    );

    shift_register_4bit shift_register_4bit_inst2 (
        .clk(clk),
        .rst(rst),
        .load(load),
        .data_in(data_in[3:0]),
        .shift_in(shift_in),
        .data_out(data_out[3:0])
    );

endmodule

module shift_register_4bit (
    input wire clk,
    input wire rst,
    input wire load,
    input wire [3:0] data_in,
    input wire shift_in,
    output reg [3:0] data_out
);

    always @(posedge clk or posedge rst) begin
        if (rst)
            data_out <= 4'b0000;
        else if (load)
            data_out <= data_in;
        else
            data_out <= {data_out[2:0], shift_in};
    end

endmodule