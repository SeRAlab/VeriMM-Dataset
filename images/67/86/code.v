module top_module(system_clock, system_rst_n, first_data_in, second_data_in, data_out_and_gate);parameter DATA_WIDTH = 8;


input system_clock;
input system_rst_n;
input [DATA_WIDTH-1:0] first_data_in;
input [DATA_WIDTH-1:0] second_data_in;


output [DATA_WIDTH-1:0] data_out_and_gate;
reg [DATA_WIDTH-1:0] data_out_and_gate;


wire [DATA_WIDTH-1:0] pre_data_out_and_gate;



assign pre_data_out_and_gate = first_data_in & second_data_in;




always@(posedge system_clock or negedge system_rst_n) begin
    if(system_rst_n==1'b0) begin
       data_out_and_gate <= 0;
    end
    else begin
       data_out_and_gate <= pre_data_out_and_gate;
    end
end

endmodule