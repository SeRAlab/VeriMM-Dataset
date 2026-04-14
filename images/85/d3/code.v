module top_module(
    input [3:0] in,
    input [1:0] ctrl,
    output reg [5:0] out
);reg [3:0] shifted;
    reg [1:0] shift_amt;
    reg [3:0] one_count;
    reg [1:0] i;
    
    // Barrel Shifter
    always @ (in, ctrl) begin
        case (ctrl)
            2'b00: shifted = in << 1;
            2'b01: shifted = in << 2;
            2'b10: shifted = in << 3;
            2'b11: shifted = in << 4;
        endcase
    end
    
    // One Counter
    always @ (shifted) begin
        one_count = 0;
        for (i = 0; i < 4; i = i + 1) begin
            if (shifted[i] == 1) begin
                one_count = one_count + 1;
            end
        end
    end
    
    // Output
    always @ (one_count, shifted) begin
        out = one_count + shifted;
    end

endmodule