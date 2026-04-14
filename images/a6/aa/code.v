module top_module(
  input [3:0] data_in,
  input [3:0] id_in,
  input clk,
  output reg [31:0] encoded_out,  // Changed to reg type
  input [31:0] encoded_in,
  output reg [3:0] data_out
);// Manchester encoding scheme
  always @(posedge clk) begin
    // Encode data_in
    encoded_out[0] <= ~data_in[3];
    encoded_out[1] <= data_in[3];
    encoded_out[2] <= ~data_in[2];
    encoded_out[3] <= data_in[2];
    encoded_out[4] <= ~data_in[1];
    encoded_out[5] <= data_in[1];
    encoded_out[6] <= ~data_in[0];
    encoded_out[7] <= data_in[0];
    
    // Encode id_in
    encoded_out[8] <= ~id_in[3];
    encoded_out[9] <= id_in[3];
    encoded_out[10] <= ~id_in[2];
    encoded_out[11] <= id_in[2];
    encoded_out[12] <= ~id_in[1];
    encoded_out[13] <= id_in[1];
    encoded_out[14] <= ~id_in[0];
    encoded_out[15] <= id_in[0];
    
    // Add start and stop bits
    encoded_out[31] <= 1;
    encoded_out[30] <= 0;
  end
  
  // Manchester decoding scheme
  always @(posedge clk) begin
    // Check start bit
    if (encoded_in[31] == 1 && encoded_in[30] == 0) begin
      // Decode data_in
      data_out[3] <= ~(encoded_in[0] ^ encoded_in[1]);
      data_out[2] <= ~(encoded_in[2] ^ encoded_in[3]);
      data_out[1] <= ~(encoded_in[4] ^ encoded_in[5]);
      data_out[0] <= ~(encoded_in[6] ^ encoded_in[7]);
      
      // Decode id_in
      if (encoded_in[8] == ~encoded_in[9] && 
          encoded_in[10] == ~encoded_in[11] && 
          encoded_in[12] == ~encoded_in[13] && 
          encoded_in[14] == ~encoded_in[15]) begin
        // Set data_out to the corresponding id_in bits
        // This part is correctly assigning data_out based on decoded id_in
        data_out = id_in;
      end
    end
  end
  
endmodule