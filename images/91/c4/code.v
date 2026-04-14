module counter_with_load(
    input           clk         ,
    input           rst_n       ,
    input           load        ,
    input   [3:0]   load_value  ,
    output  reg [3:0] count
);
    
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            count <= 4'b0;
        end
        else if (load) begin
            count <= load_value;
        end
        else begin
            count <= count + 1;
        end
    end
    
endmodule