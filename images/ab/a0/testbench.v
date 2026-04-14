`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in1;
    reg resetn;
    wire aclk;
    wire clk_ref_i;
    wire sys_clk_i;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in1(clk_in1),
        .resetn(resetn),
        .aclk(aclk),
        .clk_ref_i(clk_ref_i),
        .sys_clk_i(sys_clk_i)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in1 = 0;
        forever #5 clk_in1 = ~clk_in1;
    end

        task reset_dut;

        begin
            resetn = 0;
            #15;
            @(posedge clk_in1);
            #2 resetn = 1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Initial Reset State", test_num);
            reset_dut();
            #1;
            #1;

            check_outputs(0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: clk_ref_i toggle (2 cycles)", test_num);
            reset_dut();
            repeat(2) @(posedge clk_in1);
            #1;

            #1;


            check_outputs(0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: aclk toggle (4 cycles)", test_num);
            reset_dut();
            repeat(4) @(posedge clk_in1);
            #1;

            #1;


            check_outputs(1, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: sys_clk_i toggle (8 cycles)", test_num);
            reset_dut();
            repeat(8) @(posedge clk_in1);
            #1;

            #1;


            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Midpoint State (12 cycles)", test_num);
            reset_dut();
            repeat(12) @(posedge clk_in1);
            #1;

            #1;


            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: High states (14 cycles)", test_num);
            reset_dut();
            repeat(14) @(posedge clk_in1);
            #1;

            #1;


            check_outputs(1, 1, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Full wrap around (16 cycles)", test_num);
            reset_dut();
            repeat(16) @(posedge clk_in1);
            #1;

            #1;


            check_outputs(0, 0, 0);
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
        input expected_aclk;
        input expected_clk_ref_i;
        input expected_sys_clk_i;
        begin
            if (expected_aclk === (expected_aclk ^ aclk ^ expected_aclk) &&
                expected_clk_ref_i === (expected_clk_ref_i ^ clk_ref_i ^ expected_clk_ref_i) &&
                expected_sys_clk_i === (expected_sys_clk_i ^ sys_clk_i ^ expected_sys_clk_i)) begin
                $display("PASS");
                $display("  Outputs: aclk=%b, clk_ref_i=%b, sys_clk_i=%b",
                         aclk, clk_ref_i, sys_clk_i);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: aclk=%b, clk_ref_i=%b, sys_clk_i=%b",
                         expected_aclk, expected_clk_ref_i, expected_sys_clk_i);
                $display("  Got:      aclk=%b, clk_ref_i=%b, sys_clk_i=%b",
                         aclk, clk_ref_i, sys_clk_i);
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
        $dumpvars(0,clk_in1, resetn, aclk, clk_ref_i, sys_clk_i);
    end

endmodule
