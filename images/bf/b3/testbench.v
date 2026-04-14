`timescale 1ns/1ps

module vga_controller_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] SW;
    reg clk_50;
    reg [2:0] pixel;
    reg [2:0] read_data;
    reg reset_n;
    wire [9:0] LEDR;
    wire [3:0] VGA_B;
    wire [3:0] VGA_G;
    wire VGA_HS;
    wire [3:0] VGA_R;
    wire VGA_VS;
    wire [10:0] read_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vga_controller dut (
        .SW(SW),
        .clk_50(clk_50),
        .pixel(pixel),
        .read_data(read_data),
        .reset_n(reset_n),
        .LEDR(LEDR),
        .VGA_B(VGA_B),
        .VGA_G(VGA_G),
        .VGA_HS(VGA_HS),
        .VGA_R(VGA_R),
        .VGA_VS(VGA_VS),
        .read_addr(read_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clk_50 = 0;
        forever #5 clk_50 = ~clk_50;
    end

        task reset_dut;

        begin
            reset_n = 0;
            SW = 9'b0;
            pixel = 3'b0;
            read_data = 3'b0;
            @(posedge clk_50);
            #5 reset_n = 1;
            @(posedge clk_50);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Running Testcase %03d: Reset and LEDR Mapping", test_num);
            reset_n = 0;
            SW = 9'h0AA;
            #40;



            #1;




            check_outputs(10'h0AA, 4'h0, 4'h0, 1'b1, 4'h0, 1'b1, 11'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Running Testcase %03d: LEDR Functional Mapping", test_num);
            reset_dut();
            SW = 9'h1FF;
            #40;

            #1;


            check_outputs(10'h3FF, 4'h0, 4'h0, 1'b1, 4'h0, 1'b1, 11'h000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Running Testcase %03d: Pixel Data Path (Active Region)", test_num);
            reset_dut();
            pixel = 3'b110;


            repeat(10) @(posedge clk_50);
            #5;



            #1;




            check_outputs(10'h200, 4'hF, 4'hF, 1'b1, 4'h0, 1'b1, 11'h002);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Running Testcase %03d: Read Address Increment", test_num);
            reset_dut();


            repeat(40) @(posedge clk_50);
            #5;


            if (read_addr > 11'h000) begin
                pass_count = pass_count + 1;
                $display("PASS: read_addr advanced to %h", read_addr);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: read_addr stuck at %h", read_addr);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vga_controller Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
// Print summary
        $display("\n========================================");
        $display("Test Summary");
        $display("========================================");
        $display("Tests Passed: %0d", pass_count);
        $display("Tests Failed: %0d", fail_count);
        $display("Total Tests:  %0d", pass_count + fail_count);
        $display("========================================");

        if (fail_count == 0)
            $display("ALL TESTS PASSED!");
        else
            $display("SOME TESTS FAILED!");

        $display("\nSimulation completed at time %0t", $time);
        $finish;
    end

    // Task to check outputs
    task check_outputs;
        input [9:0] expected_LEDR;
        input [3:0] expected_VGA_B;
        input [3:0] expected_VGA_G;
        input expected_VGA_HS;
        input [3:0] expected_VGA_R;
        input expected_VGA_VS;
        input [10:0] expected_read_addr;
        begin
            if (expected_LEDR === (expected_LEDR ^ LEDR ^ expected_LEDR) &&
                expected_VGA_B === (expected_VGA_B ^ VGA_B ^ expected_VGA_B) &&
                expected_VGA_G === (expected_VGA_G ^ VGA_G ^ expected_VGA_G) &&
                expected_VGA_HS === (expected_VGA_HS ^ VGA_HS ^ expected_VGA_HS) &&
                expected_VGA_R === (expected_VGA_R ^ VGA_R ^ expected_VGA_R) &&
                expected_VGA_VS === (expected_VGA_VS ^ VGA_VS ^ expected_VGA_VS) &&
                expected_read_addr === (expected_read_addr ^ read_addr ^ expected_read_addr)) begin
                $display("PASS");
                $display("  Outputs: LEDR=%h, VGA_B=%h, VGA_G=%h, VGA_HS=%b, VGA_R=%h, VGA_VS=%b, read_addr=%h",
                         LEDR, VGA_B, VGA_G, VGA_HS, VGA_R, VGA_VS, read_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEDR=%h, VGA_B=%h, VGA_G=%h, VGA_HS=%b, VGA_R=%h, VGA_VS=%b, read_addr=%h",
                         expected_LEDR, expected_VGA_B, expected_VGA_G, expected_VGA_HS, expected_VGA_R, expected_VGA_VS, expected_read_addr);
                $display("  Got:      LEDR=%h, VGA_B=%h, VGA_G=%h, VGA_HS=%b, VGA_R=%h, VGA_VS=%b, read_addr=%h",
                         LEDR, VGA_B, VGA_G, VGA_HS, VGA_R, VGA_VS, read_addr);
                fail_count = fail_count + 1;
            end
        end
    endtask

    // Timeout watchdog
    initial begin
        #1000000; // 1ms timeout
        $display("\nERROR: Simulation timeout!");
        $finish;
    end

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,SW, clk_50, pixel, read_data, reset_n, LEDR, VGA_B, VGA_G, VGA_HS, VGA_R, VGA_VS, read_addr);
    end

endmodule
