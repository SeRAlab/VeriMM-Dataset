module shift_register(
    input               clk         ,   
    input               rst_n       ,
    input               shift_en    ,
    input               serial_in   ,
 
    output  reg [3:0]   parallel_out
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            parallel_out <= 0;
        end else if (shift_en) begin
            parallel_out <= {serial_in, parallel_out[3:1]};
        end
    end

endmodule