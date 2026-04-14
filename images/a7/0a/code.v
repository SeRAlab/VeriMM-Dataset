module top_module(A,B,C);input A,B;
    output reg C; 
    always@(*) begin
        C <= A|B;
    end
endmodule