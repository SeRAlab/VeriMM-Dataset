module top_module(
  input clk,
  input reset,
  input [7:0] data_in,
  input [1:0] shift_direction,
  input load,
  output [7:0] data_out
);reg [7:0] pipeline_reg [0:2];
  reg [1:0] pipeline_shift_dir [0:1];
  reg pipeline_load;
  
  always @(posedge clk) begin
    if (reset) begin
      pipeline_reg[0] <= 8'b00110100;
      pipeline_reg[1] <= 8'b00000000;
      pipeline_reg[2] <= 8'b00000000;
      pipeline_shift_dir[0] <= 2'b00;
      pipeline_shift_dir[1] <= 2'b00;
      pipeline_load <= 1'b0;
    end else begin
      pipeline_reg[0] <= pipeline_reg[1];
      pipeline_reg[1] <= pipeline_reg[2];
      if (pipeline_load) begin
        pipeline_reg[2] <= data_in;
      end else begin
        if (pipeline_shift_dir[0] == 2'b00) begin
          pipeline_reg[2] <= {pipeline_reg[1][6:0], pipeline_reg[1][7]}; // Corrected part select
        end else if (pipeline_shift_dir[0] == 2'b01) begin
          pipeline_reg[2] <= {pipeline_reg[2][7], pipeline_reg[1][6:0]}; // Updated for left shifting
        end else if (pipeline_shift_dir[0] == 2'b10) begin
          pipeline_reg[2] <= {pipeline_reg[1][0], pipeline_reg[2][7:1]}; // Updated for right rotating
        end else begin
          pipeline_reg[2] <= {pipeline_reg[2][6:0], pipeline_reg[1][7]}; // Corrected part select for right shifting
        end
      end
      pipeline_shift_dir[0] <= pipeline_shift_dir[1];
      pipeline_shift_dir[1] <= shift_direction;
      pipeline_load <= load;
    end
  end
  
  assign data_out = pipeline_reg[0];
  
endmodule