module top_module(
    input wire clk,
    input wire reset,
    input wire [2:0] input1_vec,
    output wire [2:0] input1_outv,
    output wire input1_o2,
    output wire input1_o1,
    output wire input1_o0,
    input wire [2:0] input2_a,
    input wire [2:0] input2_b,
    output wire [2:0] out_final
);reg [2:0] not_output;
    reg [2:0] out_xor;
    reg [2:0] out_and;
    reg [2:0] out_or;

    assign input1_outv = input1_vec;

    assign input1_o2 = input1_vec[2];
    assign input1_o1 = input1_vec[1];
    assign input1_o0 = input1_vec[0];

    always @(posedge clk) begin
        if (reset) begin
            not_output <= 3'b000;
            out_xor <= 3'b000;
            out_and <= 3'b000;
            out_or <= 3'b000;
        end else begin
            not_output <= ~{input2_a[2], input2_a[1], input2_a[0]};
            out_xor <= input2_a ^ input2_b;
            out_and <= input2_a & input2_b;
            out_or <= input2_a | input2_b;
        end
    end

    assign out_final = (input1_o2) ? not_output :
                       (input1_o1) ? out_xor :
                       (input1_o0) ? out_or :
                       out_and;

endmodule