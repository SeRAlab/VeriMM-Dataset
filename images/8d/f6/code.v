module top_module(
    input [31:0] in, // 32-bit input for byte-reversing module
    input [3:0] priority_in, // 4-bit input for priority encoder
    output reg [1:0] priority_out // 2-bit output of priority encoder
);// Byte-reversing module
    reg [7:0] shift_reg [0:3];
    reg [31:0] reversed_in;
    always @(*) begin
        shift_reg[0] = {in[7:0]};
        shift_reg[1] = {in[15:8]};
        shift_reg[2] = {in[23:16]};
        shift_reg[3] = {in[31:24]};
        reversed_in = {shift_reg[3], shift_reg[2], shift_reg[1], shift_reg[0]};
    end
    
    // Priority encoder
    always @(*) begin
        casez(priority_in)
            4'b0001: priority_out = 2'b00;
            4'b0010: priority_out = 2'b01;
            4'b0100: priority_out = 2'b10;
            4'b1000: priority_out = 2'b11;
            default: priority_out = 2'b00;
        endcase
    end

endmodule