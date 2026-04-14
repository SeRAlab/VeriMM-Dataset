module top_module(
    input [7:0] keypad,
    input [31:0]msCount,
    input en,
    input [10:0]addr,
    output reg[31:0] outputIO
);always @(*) begin
        if(en && addr == 11'd1)
            outputIO = {keypad,24'd0};
        else if( en && addr == 11'd2)
            outputIO = msCount;
        else
            outputIO = 32'b0;
    end

endmodule