module top_module(CLK, S, R_DATA, W_DATA);input CLK;
    input S; 
    input [3:0]W_DATA;
    output [3:0]R_DATA;

    reg [3:0]register = 4'b0000;
    
    assign R_DATA = register;

    always @(posedge CLK) begin
        if (S == 1'b1)
        begin
            register <= W_DATA;
        end
    end
endmodule