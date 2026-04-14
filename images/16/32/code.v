module priority_encoder (
    input [3:0] I,
    output reg [1:0] Y,
    output reg V
);
    always @(*) begin
        V = 0; // Default output valid to 0
        Y = 2'b00; // Default output to 0
        if (I[3]) begin
            Y = 2'b11; // Highest priority
            V = 1; // Valid output
        end else if (I[2]) begin
            Y = 2'b10;
            V = 1;
        end else if (I[1]) begin
            Y = 2'b01;
            V = 1;
        end else if (I[0]) begin
            Y = 2'b00;
            V = 1;
        end
    end
endmodule