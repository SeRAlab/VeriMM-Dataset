module top_module(
    input [47:0]mantise,
    input clk, clear, load,
    output reg [47:0]saved_mants
    );always @(posedge clk)
    begin
        if(clear)
            saved_mants <= 48'b0;
        else if(load)
            saved_mants <= mantise;
    end

endmodule