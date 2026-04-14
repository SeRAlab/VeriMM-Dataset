module dual_port_mem (
    input         clk,
    input         we,
    input  [3:0]  write_addr,
    input  [7:0]  write_data,
    input  [3:0]  read_addr,
    output [7:0]  read_data
);

    reg [7:0] mem [15:0];

    always @(posedge clk) begin
        if (we) begin
            mem[write_addr] <= write_data;
        end
    end

    assign read_data = mem[read_addr];
    
endmodule