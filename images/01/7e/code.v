module dvfs_controller(
    input [2:0] voltage_in, 
    input [2:0] frequency_in,
    output [2:0] voltage_out, 
    output [2:0] frequency_out
);
  
    assign voltage_out = (voltage_in + 3'b001 > 3'b111) ? 3'b111 : voltage_in + 3'b001;
    assign frequency_out = (frequency_in + 3'b010 > 3'b111) ? 3'b111 : frequency_in + 3'b010;

endmodule