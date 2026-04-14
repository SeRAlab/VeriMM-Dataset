module top_module(
    input [3:0] A,
    input [3:0] B,
    input [1:0] MODE,
    input SEL_ADD,
    output reg [4:0] RESULT,  // Change wire to reg
    output reg OVERFLOW        // Change wire to reg
);wire [4:0] sum;
    wire [4:0] diff;
    wire overflow_add;
    wire overflow_sub;
    
    assign sum = A + B;
    assign diff = A - B;
    assign overflow_add = (sum[4] == 1);
    assign overflow_sub = (diff[4] == 1);
    
    always @(*) begin
        if (SEL_ADD == 1) begin
            if (MODE == 2'b00) begin
                RESULT = sum;
                OVERFLOW = 1'b0;
            end else begin
                RESULT = {overflow_add, sum[3:0]}; // Adjust for correct concatenation
                OVERFLOW = overflow_add;
            end
        end else begin
            if (MODE == 2'b00) begin
                RESULT = diff;
                OVERFLOW = 1'b0;
            end else begin
                RESULT = {overflow_sub, diff[3:0]}; // Adjust for correct concatenation
                OVERFLOW = overflow_sub;
            end
        end
    end

endmodule