`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg in0;
    reg out;
    reg rd_clk;
    wire AS;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .out(out),
        .rd_clk(rd_clk),
        .AS(AS)
    );

    // Clock generation (10ns period)
    initial begin
        rd_clk = 0;
        forever #5 rd_clk = ~rd_clk;
    end

        task reset_dut;

        begin
            in0 = 0;
            @(posedge rd_clk);
            @(posedge rd_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Initial State (Input 0)", test_num);
            reset_dut();
            in0 = 0;
            repeat(2) @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 0 to 1 Transition", test_num);
            reset_dut();
            @(negedge rd_clk);
            in0 = 1;
            @(posedge rd_clk);
            repeat(2) @(posedge rd_clk);
            #1;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Input 1 to 0 Transition", test_num);
            reset_dut();
            in0 = 1;
            repeat(2) @(posedge rd_clk);
            @(negedge rd_clk);
            in0 = 0;
            repeat(3) @(posedge rd_clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Pulse input synchronization", test_num);
            reset_dut();
            @(negedge rd_clk);
            in0 = 1;
            @(posedge rd_clk);
            in0 = 0;
            repeat(2) @(posedge rd_clk);
            #1;

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
        input expected_AS;
        begin
            if (expected_AS === (expected_AS ^ AS ^ expected_AS)) begin
                $display("PASS");
                $display("  Outputs: AS=%b",
                         AS);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: AS=%b",
                         expected_AS);
                $display("  Got:      AS=%b",
                         AS);
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
        $dumpvars(0,in0, out, rd_clk, AS);
    end

endmodule
