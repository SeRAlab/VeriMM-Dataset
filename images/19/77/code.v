module mux4to1 (
    input wire [3:0] in,   // 4 input signals
    input wire [1:0] sel,   // 2 select lines
    output wire out        // output signal
);
    assign out = (sel == 2'b00) ? in[0] :
                 (sel == 2'b01) ? in[1] :
                 (sel == 2'b10) ? in[2] :
                                  in[3]; // sel == 2'b11
endmodule