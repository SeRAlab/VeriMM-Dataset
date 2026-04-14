`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst_n;
    wire por_n;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .por_n(por_n)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            $display("Task: Resetting DUT...");
            rst_n = 0;
            repeat (5) @(posedge clk);
            rst_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Standard POR Delay Verification", test_num);
            reset_dut();


            repeat (TEST_POR_DELAY) @(posedge clk);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Verify por_n is low during delay period", test_num);
            reset_dut();


            repeat (5) @(posedge clk);


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Verify por_n stays low when rst_n is active", test_num);

            rst_n = 0;
            repeat (TEST_POR_DELAY) @(posedge clk);


            #1;



            check_outputs(1'b0);


            rst_n = 1;
            repeat (2) @(posedge clk);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %03d: Verify re-triggering rst_n resets the POR circuit", test_num);


            reset_dut();
            repeat (TEST_POR_DELAY) @(posedge clk);


            rst_n = 0;
            repeat (2) @(posedge clk);
            rst_n = 1;


            repeat (2) @(posedge clk);
            #1;

            check_outputs(1'b0);
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
        input expected_por_n;
        begin
            if (expected_por_n === (expected_por_n ^ por_n ^ expected_por_n)) begin
                $display("PASS");
                $display("  Outputs: por_n=%b",
                         por_n);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: por_n=%b",
                         expected_por_n);
                $display("  Got:      por_n=%b",
                         por_n);
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
        $dumpvars(0,clk, rst_n, por_n);
    end

endmodule
