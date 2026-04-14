module top_module(
    Y,
    A1,
    A2,
    A3,
    B1
);output Y;
    input  A1;
    input  A2;
    input  A3;
    input  B1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Assuming you need to implement a 4-to-1 mux structure manually 
    wire sel1, sel2;
    wire [3:0] data_in;

    assign data_in = {A3, A2, A1, B1};
    
    // Using a simple combinational logic to realize a 4-to-1 multiplexer
    assign Y = (data_in[0] & ~B1 & ~A2 & ~A3) | 
               (data_in[1] & A2 & ~B1 & ~A3) | 
               (data_in[2] & ~A1 & A3 & ~B1) | 
               (data_in[3] & A1 & A3 & B1);
    
endmodule