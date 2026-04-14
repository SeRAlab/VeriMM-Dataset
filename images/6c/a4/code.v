module top_module(
    input wire [1:0] controleSS,
    input wire [31:0] dataRegOut,
    input wire [31:0] b_out,
    output reg [31:0] ss_out
);parameter primeiro_caso = 2'b00;
    parameter segundo_caso = 2'b01;
    parameter terceiro_caso = 2'b10;

    always @(*)
        begin
            if(controleSS == primeiro_caso) begin
                ss_out = b_out;
            end
            if(controleSS == segundo_caso) begin
                ss_out = {dataRegOut[31:8], b_out[7:0]};
            end
            if(controleSS == terceiro_caso) begin
                ss_out = {dataRegOut[31:16], b_out[15:0]};
            end
        end

endmodule