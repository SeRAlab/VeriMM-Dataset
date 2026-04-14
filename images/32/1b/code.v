module D_latch (
    input wire D,
    input wire CLK,
    input wire EN,
    output reg Q
);
    always @(posedge CLK or negedge EN) begin
        if (!EN)
            Q <= Q; // Hold previous state when EN is low
        else
            Q <= D; // Follow D when CLK is high and EN is high
    end
endmodule