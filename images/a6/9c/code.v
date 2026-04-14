module top_module(
  input               io_bus_cmd_valid,
  output              io_bus_cmd_ready,
  input      [2:0]    io_bus_cmd_payload_function_id,
  input      [31:0]   io_bus_cmd_payload_inputs_0,
  input      [31:0]   io_bus_cmd_payload_inputs_1,
  output              io_bus_rsp_valid,
  input               io_bus_rsp_ready,
  output              io_bus_rsp_payload_response_ok,
  output     [31:0]   io_bus_rsp_payload_outputs_0,
  input               clk
);assign io_bus_rsp_valid = io_bus_cmd_valid;
  assign io_bus_cmd_ready = io_bus_rsp_ready;
  assign io_bus_rsp_payload_response_ok = 1'b1;

  
  
  
  assign io_bus_rsp_payload_outputs_0 = io_bus_cmd_payload_function_id[0] ? 
                                           io_bus_cmd_payload_inputs_1 :
                                           io_bus_cmd_payload_inputs_0 ;


endmodule