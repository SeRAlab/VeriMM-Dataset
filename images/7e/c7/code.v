module top_module(
    input             clock,
    input             resetn,
    input      [31:0] number,

    output reg [ 6:0] seven_segments,
    output reg        dot,
    output reg [ 7:0] anodes
);function [6:0] bcd_to_seg (input [3:0] bcd);

        case (bcd)
        'h0: bcd_to_seg = 'b1000000;  
        'h1: bcd_to_seg = 'b1111001;
        'h2: bcd_to_seg = 'b0100100;  
        'h3: bcd_to_seg = 'b0110000;  
        'h4: bcd_to_seg = 'b0011001;  
        'h5: bcd_to_seg = 'b0010010;  
        'h6: bcd_to_seg = 'b0000010;  
        'h7: bcd_to_seg = 'b1111000;  
        'h8: bcd_to_seg = 'b0000000;  
        'h9: bcd_to_seg = 'b0011000;  
        'ha: bcd_to_seg = 'b0001000;  
        'hb: bcd_to_seg = 'b0000011;
        'hc: bcd_to_seg = 'b1000110;
        'hd: bcd_to_seg = 'b0100001;
        'he: bcd_to_seg = 'b0000110;
        'hf: bcd_to_seg = 'b0001110;
        endcase

    endfunction

    reg [2:0] i;

    always @ (posedge clock or negedge resetn)
    begin
        if (! resetn)
        begin
            seven_segments <=   bcd_to_seg (0);
            dot            <= ~ 0;
            anodes         <= ~ 8'b00000001;

            i <= 0;
        end
        else
        begin
            seven_segments <=   bcd_to_seg (number [i * 4 +: 4]);
            dot            <= ~ 0;
            anodes         <= ~ (1 << i);

            i <= i + 1;
        end
    end

endmodule