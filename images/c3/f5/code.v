module priority_encoder (
    input [7:0] I,
    output reg EN,
    output reg V,
    output reg [2:0] Q
);
    
    always @(*) begin
        if (|I) begin
            EN = 1;
            V = (|I) & (~&I);
            Q = $onehot0(I);
        end
        else begin
            EN = 0;
            V = 0;
            Q = 0;
        end
    end
    
endmodule