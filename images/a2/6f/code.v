module shift_register_8bit (CLK, RESET, LOAD, DATA_IN, SHIFT_IN, Q);
input CLK;
input RESET;
input LOAD;
input [7:0] DATA_IN;
input SHIFT_IN;
output reg [7:0] Q;

always @(posedge CLK) begin
    if (RESET) begin
        Q <= 8'b00000000;
    end
    else if (LOAD) begin
        Q <= DATA_IN;
    end
    else begin
        Q <= {Q[6:0], SHIFT_IN};
    end
end

endmodule