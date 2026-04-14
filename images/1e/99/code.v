module D_Latch(
    input wire D,
    input wire EN,
    output reg Q
);
    always @(EN or D) begin
        if (EN) begin
            Q <= D; // Store D when EN is high
        end 
        // Q retains its value when EN is low
    end
endmodule