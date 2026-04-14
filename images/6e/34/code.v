module register_8bit(
    input clk,
    input clr,
    input load,
    input [7:0] d,
    
    output reg [7:0] q
);
    always @(posedge clk or posedge clr) begin
        if (clr) 
            q <= 8'b00000000;
        else if (load) 
            q <= d;
    end
endmodule