module top_module(clk_25,
    xaddr,
    yaddr,
    rgb);input clk_25;
  input [9:0]xaddr;
  input [9:0]yaddr;
  output reg [23:0]rgb; // Make rgb a reg since it's assigned in an always block

  wire clk_25;
  reg [23:0] rgb_temp; // Change rgb_temp to reg
  reg [9:0] xaddr_reg; // Use a reg to modify xaddr
  reg [9:0] yaddr_reg; // Use a reg if you want to modify yaddr

  assign rgb[23:16] = rgb_temp[23:16];
  assign rgb[15:8] = rgb_temp[15:8];
  assign rgb[7:0] = rgb_temp[7:0];

  reg [2:0] state;
  reg [4:0] r_count;
  reg [5:0] g_count;
  reg [4:0] b_count;
  reg [4:0] r_data;
  reg [5:0] g_data;
  reg [4:0] b_data;

  always @(posedge clk_25) begin
    case (state)
      0: begin
        r_count <= 0;
        g_count <= 0;
        b_count <= 0;
        r_data <= 0;
        g_data <= 0;
        b_data <= 0;
        rgb_temp <= 0; // Initialize rgb_temp
        state <= 1;
        xaddr_reg <= 0; // Initialize xaddr_reg
      end
      1: begin
        if (xaddr_reg >= 640) begin
          state <= 0;
        end else begin
          r_data <= {r_data[3:0], rgb_temp[4]};
          g_data <= {g_data[4:0], rgb_temp[10:5]};
          b_data <= {b_data[3:0], rgb_temp[15:11]};
          if (r_count == 7) begin
            rgb_temp[23:16] <= {rgb_temp[23:16], r_data}; // Assign values to rgb_temp since it's a reg
            r_count <= 0;
          end else begin
            r_count <= r_count + 1;
          end
          if (g_count == 3) begin
            rgb_temp[15:8] <= {rgb_temp[15:8], g_data}; // Assign values to rgb_temp since it's a reg
            g_count <= 0;
          end else begin
            g_count <= g_count + 1;
          end
          if (b_count == 7) begin
            rgb_temp[7:0] <= {rgb_temp[7:0], b_data}; // Assign values to rgb_temp since it's a reg
            b_count <= 0;
          end else begin
            b_count <= b_count + 1;
          end
          xaddr_reg <= xaddr_reg + 1; // Increment xaddr_reg
        end
      end
    endcase
  end
endmodule