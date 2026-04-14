`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg nset;
    reg reset;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .nset(nset),
        .reset(reset),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        nset = 0;
        forever #5 nset = ~nset;
    end

        task reset_dut;

        begin
            reset = 1;
            #10;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            reset = 1;

            #20;
            $display("Testcase %0d: Reset Priority (reset=1, nset toggling)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            reset = 0;

            wait(nset == 0);
            #2;
            $display("Testcase %0d: Set Operation (reset=0, nset=0)", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            reset = 0;
            wait(nset == 0);
            #2;
            wait(nset == 1);
            #2;
            $display("Testcase %0d: De-asserting nset (Hold/Logic check)", test_num);


            #1;



            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            wait(nset == 0);
            reset = 1;
            #2;
            $display("Testcase %0d: Simultaneous nset=0 and reset=1 (Reset should win)", test_num);
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset = 1;
            wait(nset == 1);
            #2;
            $display("Testcase %0d: Simple Reset (nset=1, reset=1)", test_num);
            #1;

            check_outputs(1'b0);
            reset = 0;
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
                         Q);
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
        $dumpvars(0,nset, reset, Q);
    end

endmodule
