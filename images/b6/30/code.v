module top_module(
  input clk,                      // Added clk input
  input [k-1:0] in,
  output reg [n-1:0] out         // Changed output to reg type
);parameter k = 1024; // number of input bits
parameter n = 2048; // number of output bits
parameter m = 16; // number of memory elements in the encoder

reg [m-1:0] state1;
reg [m-1:0] state2;
reg [k-1:0] input_buffer;
reg [n-1:0] output_buffer;
integer i; // Defined integer i for use in the for loop

// Convolutional Encoder 1
always @ (posedge clk) begin
  input_buffer[m-1:0] <= input_buffer[m-2:0]; // Use non-blocking assignment
  input_buffer[0] <= in;
  
  case (state1)
    0: begin
      output_buffer[0] <= input_buffer[0] ^ input_buffer[1] ^ input_buffer[2] ^ input_buffer[3] ^ input_buffer[5] ^ input_buffer[7] ^ input_buffer[9] ^ input_buffer[11] ^ input_buffer[13] ^ input_buffer[15];
      state1 <= 1; // Use non-blocking assignment
    end
    1: begin
      output_buffer[1] <= input_buffer[0] ^ input_buffer[1] ^ input_buffer[3] ^ input_buffer[4] ^ input_buffer[6] ^ input_buffer[8] ^ input_buffer[10] ^ input_buffer[12] ^ input_buffer[14] ^ input_buffer[15];
      state1 <= 0; // Use non-blocking assignment
    end
  endcase
end

// Convolutional Encoder 2
always @ (posedge clk) begin
  input_buffer[m-1:0] <= input_buffer[m-2:0]; // Use non-blocking assignment
  input_buffer[0] <= in;
  
  case (state2)
    0: begin
      output_buffer[2] <= input_buffer[0] ^ input_buffer[1] ^ input_buffer[3] ^ input_buffer[4] ^ input_buffer[6] ^ input_buffer[8] ^ input_buffer[10] ^ input_buffer[12] ^ input_buffer[14] ^ input_buffer[15];
      state2 <= 1; // Use non-blocking assignment
    end
    1: begin
      output_buffer[3] <= input_buffer[0] ^ input_buffer[2] ^ input_buffer[3] ^ input_buffer[5] ^ input_buffer[7] ^ input_buffer[9] ^ input_buffer[11] ^ input_buffer[13] ^ input_buffer[14] ^ input_buffer[15];
      state2 <= 0; // Use non-blocking assignment
    end
  endcase
end

// Interleaver
always @ (posedge clk) begin
  for (i = 0; i < n; i = i + 2) begin
    out[i] <= output_buffer[i/2]; // Use non-blocking assignment
    out[i+1] <= output_buffer[n/2 + i/2]; // Use non-blocking assignment
  end
end

endmodule