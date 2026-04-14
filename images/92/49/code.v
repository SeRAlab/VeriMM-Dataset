module top_module(
  input      [15:0] lin,
  output reg [9:0] man,
  output reg [2:0] exp
);always @(*) begin
  casez(lin[15])
    // negative numbers
    1'b1: begin
      man = lin[15:6];
      exp = 3'd7;
    end
    // positive numbers
    1'b0: begin
      casez(lin)
        16'b0000000000000000: begin
          man = 10'b0;
          exp = 3'd0; // Fixed: Changed exp to 0 for zero input.
        end
        16'b0000000000000001: begin
          man = lin[9:0];
          exp = 3'd1; // Fixed: Updated exp to 1.
        end
        16'b000000000000001?: begin
          man = lin[8:0];
          exp = 3'd2; // Fixed: Updated exp to 2.
        end
        16'b00000000000001??: begin
          man = lin[7:0];
          exp = 3'd3; // Fixed: Updated exp to 3.
        end
        16'b0000000000001???: begin
          man = lin[6:0];
          exp = 3'd4; // Fixed: Updated exp to 4.
        end
        16'b000000000001????: begin
          man = lin[5:0];
          exp = 3'd5; // Fixed: Updated exp to 5.
        end
        16'b00000000001?????: begin
          man = lin[4:0];
          exp = 3'd6; // Fixed: Updated exp to 6.
        end
        16'b0000000001??????: begin
          man = lin[3:0];
          exp = 3'd7; // This is the max allowable exp for positive numbers.
        end
        16'b000000001???????: begin
          man = lin[2:0];
          exp = 3'd7; // Avoid exceeding 3'd7.
        end
        default: begin
          man = lin[9:0];
          exp = 3'd7; // This can be adjusted according to intended logic. 
        end
      endcase
    end
  endcase
end

endmodule