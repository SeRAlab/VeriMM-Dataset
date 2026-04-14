module top_module(
  input A, B, C, D,
  output reg [15:0] Y
);always @*
    if (A || B || C || D) begin
      case ({D, C, B, A})  // Using the inputs directly
        4'b0001: Y = 16'b0001;
        4'b0010: Y = 16'b0010;
        4'b0100: Y = 16'b0100;
        4'b1000: Y = 16'b1000;
        4'b0011: Y = 16'b0001; // Adjusted logic for multiple signals as required
        4'b0101: Y = 16'b0010;
        4'b0110: Y = 16'b0011;
        4'b1001: Y = 16'b0100;
        4'b0111: Y = 16'b0101;
        4'b1011: Y = 16'b0110;
        4'b1101: Y = 16'b1000;
        4'b1110: Y = 16'b1001;
        default: Y = 16'b1111; // No input active
      endcase
    end
    else begin
      Y = 16'b0000; // If no input active
    end

endmodule