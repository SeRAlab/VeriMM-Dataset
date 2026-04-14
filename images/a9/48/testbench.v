`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg rst_i;
    wire clk;
    wire nrst;
    wire rst;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .rst_i(rst_i),
        .clk(clk),
        .nrst(nrst),
        .rst(rst)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            @(posedge clk_i);
            #1;
            rst_i = 1;
            repeat (2) @(posedge clk_i);
            #1;
            rst_i = 0;
            $display("Reset de-asserted, waiting for internal counter...");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify reset release after 5 cycles", test_num);
            reset_dut();


            repeat (6) @(posedge clk_i);
            #2;


            #1;



            check_outputs(clk_i, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify reset active during the 5-cycle window", test_num);
            reset_dut();


            repeat (2) @(posedge clk_i);
            #2;


            #1;



            check_outputs(clk_i, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify re-triggering reset pulse", test_num);


            reset_dut();
            repeat (6) @(posedge clk_i);


            reset_dut();
            repeat (2) @(posedge clk_i);
            #2;


            #1;



            check_outputs(clk_i, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verify boundary transition at cycle 5/6", test_num);
            reset_dut();


            repeat (5) @(posedge clk_i);
            #2;
            if (rst !== 1'b1) begin
                $display("Warning: Transition might occur exactly on the 5th edge depending on implementation");
            end


            @(posedge clk_i);
            #2;


            #1;



            check_outputs(clk_i, 1'b1, 1'b0);
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
        input expected_clk;
        input expected_nrst;
        input expected_rst;
        begin
            if (expected_clk === (expected_clk ^ clk ^ expected_clk) &&
                expected_nrst === (expected_nrst ^ nrst ^ expected_nrst) &&
                expected_rst === (expected_rst ^ rst ^ expected_rst)) begin
                $display("PASS");
                $display("  Outputs: clk=%b, nrst=%b, rst=%b",
                         clk, nrst, rst);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk=%b, nrst=%b, rst=%b",
                         expected_clk, expected_nrst, expected_rst);
                $display("  Got:      clk=%b, nrst=%b, rst=%b",
                         clk, nrst, rst);
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
        $dumpvars(0,clk_i, rst_i, clk, nrst, rst);
    end

endmodule
