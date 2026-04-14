module top_module(
    input [3:0] A, B,
    output reg [7:0] result  // Change here from wire to reg
);reg [7:0] temp;
reg [2:0] i;

always @(*) begin
    temp = 0;
    for(i = 0; i < 4; i = i + 1) begin
        if(B[i] == 1) begin
            temp = temp + (A << i);
        end
    end
    result = temp; // This assignment is now valid
end

endmodule