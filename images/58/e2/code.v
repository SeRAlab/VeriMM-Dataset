module top_module(
  input               cmd_valid,
  output              cmd_ready,
  input      [9:0]    cmd_payload_function_id,
  input      [31:0]   cmd_payload_inputs_0,
  input      [31:0]   cmd_payload_inputs_1,
  output              rsp_valid,
  input               rsp_ready,
  output     [31:0]   rsp_payload_outputs_0,
  input               reset,
  input               clk
);reg [31:0] output_value;

  always @(*) begin
    if (cmd_payload_function_id[0] == 1'b0) begin
      output_value = cmd_payload_inputs_0;
    end else begin
      output_value = cmd_payload_inputs_1;
    end
  end

  assign rsp_payload_outputs_0 = output_value;

  reg cmd_ready_reg;
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      cmd_ready_reg <= 1'b0;
    end else begin
      cmd_ready_reg <= rsp_ready;
    end
  end

  assign cmd_ready = cmd_ready_reg;

  reg rsp_valid_reg;
  always @(posedge clk, posedge reset) begin
    if (reset) begin
      rsp_valid_reg <= 1'b0;
    end else begin
      rsp_valid_reg <= cmd_valid;
    end
  end

  assign rsp_valid = rsp_valid_reg;

endmodule