module fixed_priority_arbiter (
    input wire [2:0] req,
    output reg [2:0] grant
);
    always @(*) begin
        grant = 3'b000; // default grant is none
        if (req[0]) begin
            grant[0] = 1; // grant to req[0]
        end else if (req[1]) begin
            grant[1] = 1; // grant to req[1]
        end else if (req[2]) begin
            grant[2] = 1; // grant to req[2]
        end
    end
endmodule