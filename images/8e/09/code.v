module top_module(
    input d,
    input clk,
    input clrn,
    input aload,
    input sload,
    output reg q
    );always @ (posedge clk) begin
        if (clrn == 1'b0) // asynchronous reset
            q <= 1'b0;
        else if (aload == 1'b1) // asynchronous load
            q <= d;
        else if (sload == 1'b1) // synchronous load
            q <= d;
    end

endmodule