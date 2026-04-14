module shift_register(clk, reset, load, data_in, shift_in, q);

    input clk;
    input reset;
    input load;
    input [7:0] data_in;
    input shift_in;
    output [7:0] q;
    reg [7:0] q;
    initial q = 8'b00000000;

    always @(posedge clk)
        begin
            if (reset)
                q <= 8'b00000000;
            else if (load)
                q <= data_in;
            else
                q <= {q[6:0], shift_in};
        end

endmodule