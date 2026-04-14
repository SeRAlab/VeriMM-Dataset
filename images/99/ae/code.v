module top_module(
        input reg_addr, 
        input stack_command,
        input [7:0] stack_pointer,
        input [7:0] addr,
        input [15:0] alu_result,
        output reg [7:0] true_addr
    );always@* begin
        if(reg_addr == 1) begin
            true_addr = alu_result[7:0];
        end
        else if( stack_command == 1 ) begin
            true_addr = stack_pointer;
        end
        else begin
            true_addr = addr;
        end
    end
endmodule