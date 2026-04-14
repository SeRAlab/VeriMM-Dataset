module top_module(
    input wire Clock,
    input wire Reset,
    input wire Enable,
    input wire [SIZE-1:0] D,
    output reg [SIZE-1:0] Q
);parameter SIZE = 1;

    always @(posedge Clock or posedge Reset) begin
        if (Reset) begin
            Q <= 0;
        end else if (Enable) begin
            Q <= D;
        end
    end
endmodule