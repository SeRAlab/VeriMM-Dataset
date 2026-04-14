module top_module(
   input [3:0] data_in,
   input cin,
   output reg combout,
   output reg cout
);parameter lut_mask = 16'hFFFF;
   parameter sum_lutc_input = "datac";

   function lut_data;
      input [15:0] mask;
      input [3:0] data_in;
      input cin;
      reg [7:0] s3;
      reg [3:0] s2;
      reg [1:0] s1;
      begin
         s3 = cin ? mask[15:8] : mask[7:0];
         s2 = data_in[2] ? s3[7:4] : s3[3:0];
         s1 = data_in[1] ? s2[3:2] : s2[1:0];
         lut_data = data_in[0] ? s1[1] : s1[0];
      end
   endfunction

   always @(*) begin
      if (sum_lutc_input == "datac") begin
         combout = lut_data(lut_mask, data_in, 1'b0);
      end else begin
         combout = lut_data(lut_mask, data_in, cin);
      end
      cout = lut_data(lut_mask, data_in, 1'b0);
   end

endmodule