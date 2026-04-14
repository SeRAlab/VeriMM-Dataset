module top_module(I, O);input  wire I;
    output wire O;

    parameter MODE="PASSTHROUGH";

    
    generate if (MODE == "PASSTHROUGH") begin
        assign O = I;

    
    end else if (MODE == "INVERT") begin
        NOT inverter(I, O);

    end endgenerate
endmodule