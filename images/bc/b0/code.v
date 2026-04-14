module shift_register
    (
        input clk,
        input load,
        input [1:0] parallel_in,
        input serial_in,
        output reg [1:0] q
    );

    always @(posedge clk) 
    begin
        if (load)
            q <= parallel_in;
        else
            q <= {q[0], serial_in};
    end

endmodule