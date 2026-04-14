module shift_register_4bit (clk, reset, load, data_in, data_out);
   input clk, reset, load;
   input [3:0] data_in;
   output data_out;

   reg [3:0] shift_reg;
   reg data_out;

always @(posedge clk or posedge reset) begin
    if (reset) 
    begin
        shift_reg <= 4'b0000;
        data_out <= 0;
    end 
    else 
    begin
        if (load) 
            shift_reg <= data_in;
        else 
        begin
            data_out <= shift_reg[3];
            shift_reg <= {shift_reg[2:0], 1'b0};
        end
    end
end

endmodule