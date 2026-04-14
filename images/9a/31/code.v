module top_module(clk, control, data_input1, data_input2, data_output, zero);input clk;
input [3:0] control;
input signed [31:0] data_input1, data_input2;

output reg signed [31:0] data_output;
output reg zero;




always@(posedge clk)

begin
    
    if (control == 4'b0010) begin
        data_output = data_input1 + data_input2;
        zero = 0;
    end


    
    else if (control == 4'b0110)
	begin
        data_output = data_input1 - data_input2;
        if (data_output == 0)
	        zero = 1;
	    else
	        zero = 0;
    end


    
    else if (control == 4'b0000) begin
        data_output = data_input1 & data_input2;
        zero = 0;
    end


    
    else if (control == 4'b0001) begin
	data_output = data_input1 | data_input2;
	zero = 0;
    end


    
    else if (control == 4'b0111) begin
        if (data_input2 < data_input1)
            data_output = 1;
        else
            data_output = 0;
        zero = 0;
    end

    
    else if (control == 4'b1100) begin
	data_output = ~(data_input1 | data_input2);
        zero =0;
    end

    else
    begin
        data_output = 0;
        zero =0;
    end

end


endmodule