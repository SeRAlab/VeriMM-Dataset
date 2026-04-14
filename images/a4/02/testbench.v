`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg add_en;
    reg clk_1;
    reg rst;
    wire [3:0] d1_12;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .add_en(add_en),
        .clk_1(clk_1),
        .rst(rst),
        .d1_12(d1_12)
    );

    // Clock generation (10ns period)
    initial begin
        clk_1 = 0;
        forever #5 clk_1 = ~clk_1;
    end

        task reset_dut;

        begin
            rst = 1;
            add_en = 0;
            @(posedge clk_1);
            #1 rst = 0;
            @(posedge clk_1);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Initial Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Increment 0 to 1", test_num);
            reset_dut();
            @(posedge clk_1);
            add_en = 1;
            @(posedge clk_1);
            #1 add_en = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Wrap around (0->1->0)", test_num);
            reset_dut();
            @(posedge clk_1);
            add_en = 1;
            @(posedge clk_1);
            @(posedge clk_1);
            #1 add_en = 0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: add_en low (stays at 0)", test_num);
            reset_dut();
            @(posedge clk_1);
            add_en = 0;
            repeat(3) @(posedge clk_1);
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Increment then hold", test_num);
            reset_dut();
            @(posedge clk_1);
            add_en = 1;
            @(posedge clk_1);
            #1 add_en = 0;
            repeat(2) @(posedge clk_1);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Multiple wrap arounds (0->1->0->1)", test_num);
            reset_dut();
            @(posedge clk_1);
            add_en = 1;
            repeat(3) @(posedge clk_1);
            #1 add_en = 0;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Reset while at 1", test_num);
            reset_dut();
            @(posedge clk_1);
            add_en = 1;
            @(posedge clk_1);
            #1 rst = 1;
            @(posedge clk_1);
            #1 rst = 0;
            #1;

            check_outputs(4'h0);
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
        input [3:0] expected_d1_12;
        begin
            if (expected_d1_12 === (expected_d1_12 ^ d1_12 ^ expected_d1_12)) begin
                $display("PASS");
                $display("  Outputs: d1_12=%h",
                         d1_12);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d1_12=%h",
                         expected_d1_12);
                $display("  Got:      d1_12=%h",
                         d1_12);
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
        $dumpvars(0,add_en, clk_1, rst, d1_12);
    end

endmodule
