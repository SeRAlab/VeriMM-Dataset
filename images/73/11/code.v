module top_module(
  input clk,
  input tone_sel,
  output reg tone_out
);parameter tone_type = "sine"; // type of tone to be generated
parameter tone_frequency = 1000; // frequency of the tone
parameter tone_duration = 100; // duration of the tone in clock cycles (assuming a 1 kHz clock)

reg [31:0] counter;
reg [31:0] duration_counter;

always @(posedge clk) begin
  if (duration_counter < tone_duration) begin
    counter <= counter + (32'hFFFFFFFF / (tone_frequency - 1));
    duration_counter <= duration_counter + 1;
  end else begin
    duration_counter <= 0;
  end
end

always @(posedge clk) begin
  case (tone_type)
    "sine": begin
      if (tone_sel) begin
        tone_out <= (counter[31] == 1'b1);
      end
    end
    "square": begin
      if (tone_sel) begin
        tone_out <= (counter[31:16] < 16'h8000);
      end
    end
  endcase
end

endmodule