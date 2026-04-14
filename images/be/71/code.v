module top_module(input D, C, E, CLR, output reg Q);wire CLR_bar;

    assign CLR_bar = ~CLR;

    always @(posedge C or posedge CLR) begin
        if (CLR) 
            Q <= 1'b0;
        else if (E) 
            Q <= Q; // Hold state if E is high
        else 
            Q <= D;
    end
endmodule