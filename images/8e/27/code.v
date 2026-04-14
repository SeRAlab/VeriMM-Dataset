module mult(
    input               clk         ,   
    input               rst_n       ,
    input       [7:0]   data_in     ,
    input               valid_in     ,
 
    output  reg         valid_out     ,
    output  reg [31:0]  data_out
);
    
    reg [1:0] count;
    reg [31:0] product;
    wire add_cnt;
    wire ready_add;
    wire end_cnt;

    assign add_cnt = ready_add;
    assign end_cnt = ready_add && (count == 3);

    //count
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            count <= 0;
        end
        else if(end_cnt) begin
            count <= 0;
        end
        else if(add_cnt) begin
            count <= count + 1;
        end
    end

    //product
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            product <= 1;
        end
        else if(add_cnt && count == 0) begin
            product <= data_in;
        end
        else if(add_cnt) begin
            product <= product * data_in;
        end
    end

    //data_out
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            data_out <= 0;
        end
        else if(end_cnt) begin
            data_out <= product;
        end
    end

    //ready_add
    assign ready_add = valid_in;

    //valid_out
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            valid_out <= 0;
        end
        else if(end_cnt) begin
            valid_out <= 1;
        end
        else begin
            valid_out <= 0;
        end
    end
    
endmodule