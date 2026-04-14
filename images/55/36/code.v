module top_module(in,load,out,clock,reset);input [31:0] in;
    input clock,reset,load;
    output [31:0] out;

    reg [31:0] out;
    
    always@(posedge clock) begin
        if(reset)begin
            out <= 32'b00000000000000000000000000000000;
        end else if(load)begin
            out <= in;
        end else begin
            out <= out;
        end
    end
endmodule