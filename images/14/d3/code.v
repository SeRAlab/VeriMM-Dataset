module T_latch (
    input wire T,
    input wire clk,
    input wire EN,
    output reg Q
);
    always @(posedge clk) begin
        if (EN) begin
            if (T) 
                Q <= ~Q; // Toggle the output
        end
    end
endmodule