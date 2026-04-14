module top_module(
    in,
    is_one_hot
);parameter WIDTH = 10;

    input      [WIDTH-1: 0] in;
    output                  is_one_hot;

    reg out;
    assign is_one_hot = out;

    
    

    always @(*)
    begin
        case (in)
            10'b00_0000_0001: out = 1'b1;
            10'b00_0000_0010: out = 1'b1;
            10'b00_0000_0100: out = 1'b1;
            10'b00_0000_1000: out = 1'b1;
            10'b00_0001_0000: out = 1'b1;
            10'b00_0010_0000: out = 1'b1;
            10'b00_0100_0000: out = 1'b1;
            10'b00_1000_0000: out = 1'b1;
            10'b01_0000_0000: out = 1'b1;
            10'b10_0000_0000: out = 1'b1;
            10'b00_0000_0000: out = 1'b1;
            default: out = 1'b0;
        endcase
    end
endmodule