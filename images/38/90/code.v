module deadbeat_controller(
    input [3:0] x,
    output reg [3:0] y
);
    always @(*) begin
        if (x == 4'b1111) 
            y = 4'b0000; // Output to zero if the input is 15
        else 
            y = 4'b0001; // Otherwise output is 1
    end
endmodule