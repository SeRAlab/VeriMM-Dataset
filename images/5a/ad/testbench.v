`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg hsync;
    reg rst;
    reg vsync;
    reg [9:0] x;
    reg [9:0] y;
    wire [7:0] b;
    wire [7:0] g;
    wire [7:0] r;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hsync(hsync),
        .rst(rst),
        .vsync(vsync),
        .x(x),
        .y(y),
        .b(b),
        .g(g),
        .r(r)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        rst = 1;
        hsync = 0;
        vsync = 0;
        x = 0;
        y = 0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Active Region - X=128, Y=100", test_num);
        x = 10'd128;
        y = 10'd100;
        hsync = 1'b1;
        vsync = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'd128, 8'd128, 8'd128);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Horizontal Sync Active - RGB should be 0", test_num);
        x = 10'd128;
        y = 10'd100;
        hsync = 1'b0;
        vsync = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Vertical Sync Active - RGB should be 0", test_num);
        x = 10'd128;
        y = 10'd100;
        hsync = 1'b1;
        vsync = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Active Region - X=255, Y=200", test_num);
        x = 10'd255;
        y = 10'd200;
        hsync = 1'b1;
        vsync = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'hFF, 8'hFF, 8'hFF);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Gradient Wrap - X=256", test_num);
        x = 10'd256;
        y = 10'd10;
        hsync = 1'b1;
        vsync = 1'b1;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    task testcase006;

    begin
        reset_dut();
        test_num = test_num + 1;
        $display("Testcase %0d: Both Syncs Active - RGB should be 0", test_num);
        x = 10'd50;
        y = 10'd50;
        hsync = 1'b0;
        vsync = 1'b0;
        @(posedge clk);
        #1 #1;
 check_outputs(8'h00, 8'h00, 8'h00);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [7:0] expected_b;
        input [7:0] expected_g;
        input [7:0] expected_r;
        begin
            if (expected_b === (expected_b ^ b ^ expected_b) &&
                expected_g === (expected_g ^ g ^ expected_g) &&
                expected_r === (expected_r ^ r ^ expected_r)) begin
                $display("PASS");
                $display("  Outputs: b=%h, g=%h, r=%h",
                         b, g, r);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h, g=%h, r=%h",
                         expected_b, expected_g, expected_r);
                $display("  Got:      b=%h, g=%h, r=%h",
                         b, g, r);
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
        $dumpvars(0,clk, hsync, rst, vsync, x, y, b, g, r);
    end

endmodule
