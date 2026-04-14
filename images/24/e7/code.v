module decision_tree (
    input wire X1,
    input wire X2,
    input wire X3,
    output reg Y
);
    always @(*) begin
        if (X1) begin
            if (X2) begin
                Y = 1; // Path: X1==1, X2==1
            end else begin
                Y = 0; // Path: X1==1, X2==0
            end
        end else begin
            if (X3) begin
                Y = 1; // Path: X1==0, X3==1
            end else begin
                Y = 0; // Path: X1==0, X3==0
            end
        end
    end
endmodule