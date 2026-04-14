module bin_to_7seg(
    input [1:0] bin,
    
    output reg [6:0] seg
);

always @(*) begin
    case (bin)
        2'b00: seg = 7'b0000001; // Display 0
        2'b01: seg = 7'b1001111; // Display 1
        2'b10: seg = 7'b0010010; // Display 2
        2'b11: seg = 7'b0000110; // Display 3
        default: seg = 7'b1111111; // Display nothing
    endcase
end

endmodule