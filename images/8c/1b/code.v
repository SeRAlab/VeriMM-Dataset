module shift_register_8bit(
    input clk, 
    input reset, 
    input load, 
    input shift_en, 
    input [7:0] data_in, 
    output reg [7:0] q);

    always @(posedge clk) begin
        if (reset) 
            q <= 8'b00000000;
        else if (load) 
            q <= data_in;
        else if (shift_en) 
            q <= {q[6:0], 1'b0};
    end
endmodule