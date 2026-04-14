module T_latch (
    input T,
    input CLK,
    output reg Q
);
    always @(posedge CLK) begin
        if (T) 
            Q <= ~Q; // Toggle operation
    end
endmodule