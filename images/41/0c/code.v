module memory_block(
    input               clk         ,   
    input               rst_n       ,
    input       [3:0]   addr        ,
    input       [7:0]   data_in     ,
    input               write_en    ,
    input               read_en     ,
 
    output  reg [7:0]   data_out
);
    
    reg [7:0] mem [15:0];

    // Write logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Optionally initialize memory here
        end else if (write_en) begin
            mem[addr] <= data_in;
        end
    end

    // Read logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            data_out <= 0;
        end else if (read_en) begin
            data_out <= mem[addr];
        end
    end

endmodule