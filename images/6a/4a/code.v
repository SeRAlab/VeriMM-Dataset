module top_module(
  input clk,
  input areset, // Async active-high reset to zero
  input load,
  input ena,
  input [31:0] data_in, // 32-bit input data for the barrel shifter
  input [4:0] shift_amount, // 5-bit shift amount input for the barrel shifter
  output [31:0] data_out, // 32-bit output of the barrel shifter
  output zero_flag, // Flag indicating whether the shifted output is zero
  input [3:0] reg_data_in, // 4-bit input data for the shift register
  output reg [3:0] q // 4-bit output of the shift register
);// Barrel shifter
  reg [31:0] shifted_data;
  assign zero_flag = (shifted_data == 0);
  
  always @ (posedge clk) begin
    if (areset) begin
      shifted_data <= 0;
    end else begin
      shifted_data <= (shift_amount[4]) ? {32{shifted_data[31]}} : // Arithmetic shift right
                      (shift_amount[3]) ? {shifted_data[31:16], shifted_data[15:0]} : // Logical shift right
                      (shift_amount[2]) ? {shifted_data[15:0], 16'h0000} : // Logical shift left
                      (shift_amount[1]) ? {shifted_data[7:0], shifted_data[31:8]} : // Logical shift left
                      (shift_amount[0]) ? {shifted_data[3:0], shifted_data[31:4]} : // Logical shift left
                                         shifted_data; // No shift
    end
  end
  
  // Shift register
  reg [3:0] counter;
  reg [3:0] reg_data;
  wire [31:0] mux_data;
  assign mux_data = (load) ? reg_data_in : q;
  assign data_out = shifted_data + mux_data;
  
  always @ (posedge clk) begin
    if (areset) begin
      counter <= 0;
      reg_data <= 0;
      q <= 0;
    end else if (ena) begin
      if (load) begin
        counter <= 0;
        reg_data <= reg_data_in;
        q <= reg_data_in;
      end else begin
        if (counter == 3) begin
          q <= mux_data[3:0];
        end else begin
          q <= {q[2:0], 1'b0};
        end
        counter <= counter + 1;
      end
    end
  end

endmodule