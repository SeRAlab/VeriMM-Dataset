`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [11:0] a;
    reg [24:0] b;
    reg clk;
    reg rst;
    wire [36:0] p;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .rst(rst),
        .p(p)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Reset and Zero", test_num);
        rst = 1; a = 12'sd0; b = 25'sd0;
        @(posedge clk);
        #1 rst = 0;
        @(posedge clk);
        #1;

        check_outputs(37'sd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: 10 * 20", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sd10; b = 25'sd20;
        @(posedge clk);
        #1;

        check_outputs(37'sd200);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: -10 * 50", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = -12'sd10; b = 25'sd50;
        @(posedge clk);
        #1;

        check_outputs(-37'sd500);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: 123 * -456", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sd123; b = -25'sd456;
        @(posedge clk);
        #1;

        check_outputs(-37'sd56088);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: -15 * -30", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = -12'sd15; b = -25'sd30;
        @(posedge clk);
        #1;

        check_outputs(37'sd450);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: 1 * -1", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sd1; b = -25'sd1;
        @(posedge clk);
        #1;

        check_outputs(-37'sd1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Max Positive Values", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sh7FF; b = 25'sh0FFFFFF;
        @(posedge clk);
        #1;

        check_outputs(37'sd34342959105);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Min Negative Values", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sh800; b = 25'sh1000000;
        @(posedge clk);
        #1;

        check_outputs(37'sd34359738368);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Max Pos * Min Neg", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sh7FF; b = 25'sh1000000;
        @(posedge clk);
        #1;

        check_outputs(-37'sd34342961152);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Running testcase %0d: Min Neg * Max Pos", test_num);
        rst = 1;
        @(posedge clk);
        #1 rst = 0; a = 12'sh800; b = 25'sh0FFFFFF;
        @(posedge clk);
        #1;

        check_outputs(-37'sd34359736320);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
        input [36:0] expected_p;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_p === (expected_p ^ p ^ expected_p)) begin
                $display("PASS");
                $display("  Outputs: p=%h",
                         p);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: p=%h",
                         expected_p);
                $display("  Got:      p=%h",
                         p);
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

endmodule
