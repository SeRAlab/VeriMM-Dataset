module top_module(input [4:0] A1ADDR, input A1DATA, A1EN,
    (* clkbuf_sink *) input CLK1,
    input [4:0] B1ADDR, output B1DATA);reg [31:0] mem = 32'b0;


specify
    $setup(A1ADDR, posedge CLK1, 86);
    $setup(A1DATA, posedge CLK1, 86);
    $setup(A1EN, posedge CLK1, 86);

    (B1ADDR[0] => B1DATA) = 487;
    (B1ADDR[1] => B1DATA) = 475;
    (B1ADDR[2] => B1DATA) = 382;
    (B1ADDR[3] => B1DATA) = 284;
    (B1ADDR[4] => B1DATA) = 96;
endspecify

always @(posedge CLK1)
    if (A1EN) mem[A1ADDR] <= A1DATA;

assign B1DATA = mem[B1ADDR];

endmodule