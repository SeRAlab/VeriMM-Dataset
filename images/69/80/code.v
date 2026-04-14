module top_module(
    input a,
    input b,
    input c,
    input d,
    output reg highest_priority,
    output reg [1:0] binary_code
);// 2-to-1 MUX using NAND gates
    wire nand1, nand2, nand3, nand4, nand5, nand6;
    assign nand1 = ~(a & b);
    assign nand2 = ~(b & c);
    assign nand3 = ~(c & d);
    assign nand4 = ~(nand1 & nand2);
    assign nand5 = ~(nand2 & nand3);
    assign nand6 = ~(nand4 & nand5);
    
    // 3-to-1 MUX using NAND gates
    wire nand7, nand8, nand9;
    assign nand7 = ~(a & b & c);
    assign nand8 = ~(b & c & d);
    assign nand9 = ~(a & c & d);
    
    // Output logic
    always @* begin
        if (nand6) begin
            highest_priority = 1;
            binary_code = 2'b00;
        end else if (nand7) begin
            highest_priority = 0;
            binary_code = 2'b01;
        end else if (nand8) begin
            highest_priority = 0;
            binary_code = 2'b10;
        end else if (nand9) begin
            highest_priority = 0;
            binary_code = 2'b11;
        end else begin
            highest_priority = 0;
            binary_code = 2'b00;
        end
    end
    
endmodule