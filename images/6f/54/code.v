module top_module(
    input [5:0] op,
    input [31:0] alu_result,
    input [31:0] dm_data,
    output [31:0] result
    );function [31:0] result_gen;
        input [5:0] op;
        input [31:0] alu_result, dm_data;
        case(op)
            6'd16:result_gen=dm_data;
            6'd18:result_gen={{16{dm_data[15]}},dm_data[15:0]};
            6'd20:result_gen={{24{dm_data[7]}},dm_data[7:0]};
            default:result_gen=alu_result;
        endcase
    endfunction

    assign result = result_gen(op,alu_result,dm_data);

endmodule