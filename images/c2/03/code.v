module one_shot (
  input trigger,
  output pulse
);

  parameter pulse_width = 10; // pulse width in time units
  
  reg [7:0] count; // 8-bit counter to count up to pulse_width
  
  always @(posedge trigger) begin
    count <= 0; // reset counter on trigger
    pulse <= 1; // set pulse high on trigger
  end
  
  always @(posedge clk) begin
    if (count < pulse_width) begin
      count <= count + 1; // increment counter
    end else begin
      pulse <= 0; // set pulse low after pulse_width
    end
  end
  
endmodule