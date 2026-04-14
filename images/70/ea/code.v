module shift_register_8bit(
    input clk, load, 
    input [7:0] d, 
    input si, 
    output reg [7:0] q);
    
    always @(posedge clk) begin
        if (load)
            q <= d;
        else
            q <= {q[6:0], si};
    end
endmodule