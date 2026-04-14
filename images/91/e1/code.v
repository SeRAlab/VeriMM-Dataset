module bin_to_7seg(bin, seg);
    input [2:0] bin;
    output reg [6:0] seg;

    always @(*) begin
        case (bin)
            3'b000: seg = 7'b0000001; // Display 0
            3'b001: seg = 7'b1001111; // Display 1
            3'b010: seg = 7'b0010010; // Display 2
            3'b011: seg = 7'b0000110; // Display 3
            3'b100: seg = 7'b1001100; // Display 4
            3'b101: seg = 7'b0100100; // Display 5
            3'b110: seg = 7'b0100000; // Display 6
            3'b111: seg = 7'b0001111; // Display 7
            default: seg = 7'b1111111; // Display nothing (all segments off)
        endcase
    end
endmodule