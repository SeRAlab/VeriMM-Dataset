module shift_register(
    input [7:0] d,
    input clk,
    input load,
    input s_in,
    output reg [7:0] q
    );

    always @ (posedge clk)
    begin
        if (load)
            q = d;
        else
            q = {s_in, q[7:1]};
    end
endmodule