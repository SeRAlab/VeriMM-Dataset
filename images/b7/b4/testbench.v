`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg detect;
    reg i_shutdown;
    reg los;
    wire o_detect;
    wire o_los;
    wire shutdown;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .detect(detect),
        .i_shutdown(i_shutdown),
        .los(los),
        .o_detect(o_detect),
        .o_los(o_los),
        .shutdown(shutdown),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            detect = 0;
            los = 0;
            i_shutdown = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %0d: Testing o_detect (inverted detect)", test_num);
            reset_dut();


            detect = 1;
            #2;


            #1;



            check_outputs(0, 0, 0, tx);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %0d: Testing o_los and shutdown passthrough", test_num);
            reset_dut();

            detect = 0;
            los = 1;
            i_shutdown = 1;
            #2;

            #1;


            check_outputs(1, 1, 1, tx);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("\nTestcase %0d: Testing tx signal toggle (50 cycles)", test_num);
            reset_dut();



            repeat(48) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %0d: Testing tx signal toggle (100 cycles)", test_num);
            reset_dut();


            repeat(100) @(posedge clk);
            #2;

            #1;


            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %0d: Combined logic verification", test_num);
            reset_dut();

            detect = 1;
            los = 0;
            i_shutdown = 1;
            #2;

            #1;


            check_outputs(0, 0, 1, tx);
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
        input expected_o_detect;
        input expected_o_los;
        input expected_shutdown;
        input expected_tx;
        begin
            if (expected_o_detect === (expected_o_detect ^ o_detect ^ expected_o_detect) &&
                expected_o_los === (expected_o_los ^ o_los ^ expected_o_los) &&
                expected_shutdown === (expected_shutdown ^ shutdown ^ expected_shutdown) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: o_detect=%b, o_los=%b, shutdown=%b, tx=%b",
                         o_detect, o_los, shutdown, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_detect=%b, o_los=%b, shutdown=%b, tx=%b",
                         expected_o_detect, expected_o_los, expected_shutdown, expected_tx);
                $display("  Got:      o_detect=%b, o_los=%b, shutdown=%b, tx=%b",
                         o_detect, o_los, shutdown, tx);
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
        $dumpvars(0,clk, detect, i_shutdown, los, o_detect, o_los, shutdown, tx);
    end

endmodule
