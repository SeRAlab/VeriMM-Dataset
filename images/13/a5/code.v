module lzw_compressor(
    input clk,
    input rst,
    input [7:0] data_in,
    input data_valid,
    output reg [11:0] code_out,
    output reg code_valid
);
    reg [3:0] state;
    reg [3:0] next_state;
    
    // Dictionary size and initialization
    reg [7:0] dictionary[0:15]; // 16 entries for simplicity
    reg [3:0] dict_size;
    
    // States
    localparam IDLE = 0, READ = 1, MATCH = 2, OUTPUT = 3, RESET = 4;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            dict_size <= 0;
            code_valid <= 0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            IDLE: begin
                if (data_valid) next_state = READ;
            end
            READ: begin
                // Add input to the dictionary if space allows
                if (dict_size < 16) begin
                    dictionary[dict_size] = data_in;
                    dict_size = dict_size + 1;
                end
                next_state = MATCH;
            end
            MATCH: begin
                // Logic for finding a match
                // For simplicity, we will just output the first entry as code
                code_out = 12'b000000000001; // Example match code
                code_valid = 1;
                next_state = OUTPUT;
            end
            OUTPUT: begin
                code_valid = 0;
                next_state = IDLE;
            end
        endcase
    end
endmodule