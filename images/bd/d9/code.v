module top_module(
    X,
    A
);output X;
    input  A;
    parameter N = 10;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    wire [N-1:0] intermediate_wires;
    wire [N-1:0] inverted_wires;

    assign intermediate_wires[0] = A;
    assign inverted_wires[0] = ~A;

    generate
    genvar i;
    for (i=1; i<N; i=i+1) begin : inverters
        assign intermediate_wires[i] = inverted_wires[i-1];
        assign inverted_wires[i] = ~intermediate_wires[i];
    end
    endgenerate

    assign X = inverted_wires[N-1];

endmodule