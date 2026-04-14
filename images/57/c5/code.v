module top_module(
    input clk,
    input reset,
    input shift,
    input [7:0] data_in,
    output [7:0] data_out
);reg [7:0] buffer;
reg [2:0] pointer;

always @(posedge clk) begin
    if (reset) begin
        buffer <= 8'b0;
        pointer <= 3'b0;
    end else if (shift) begin
        buffer[pointer] <= data_in;
        pointer <= pointer + 1;
        if (pointer == 3'b100) begin
            pointer <= 3'b0;
        end
    end
end

assign data_out = {buffer[pointer], buffer[(pointer+1)%8], buffer[(pointer+2)%8], buffer[(pointer+3)%8], buffer[(pointer+4)%8], buffer[(pointer+5)%8], buffer[(pointer+6)%8], buffer[(pointer+7)%8]};

endmodule