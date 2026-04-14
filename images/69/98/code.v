module top_module(input CLOCK, input [31:0] my_m_value, output reg new_clock=0);reg [31:0] count = 0;

    always @ (posedge CLOCK) begin
        count <= (count == my_m_value)? 0 : count + 1;
        new_clock <= (count == 0) ? ~new_clock : new_clock ;
    end

endmodule