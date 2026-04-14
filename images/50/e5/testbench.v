`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AR;
    reg CLK;
    reg E;
    reg O;
    wire add_overflow_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AR(AR),
        .CLK(CLK),
        .E(E),
        .O(O),
        .add_overflow_flag(add_overflow_flag)
    );

    // Clock generation (10ns period)
    initial begin
        AR = 0;
        forever #5 AR = ~AR;
    end

        task reset_dut;

        begin
            AR = 0;
            E = 0;
            O = 0;
            #12;
            AR = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            E = 1;
            O = 1;


            #2;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            E = 1;
            O = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            E = 1;
            O = 1;
            @(posedge CLK);
            #2;
            E = 0;
            #2;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            E = 1;
            O = 1;
            @(posedge CLK);
            #2;
            O = 0;
            #2;

            #1;


            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            E = 0;
            O = 1;
            @(posedge CLK);
            #2;
            E = 1;
            O = 1;
            #2;

            #1;


            check_outputs(0);
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
        input expected_add_overflow_flag;
        begin
            if (expected_add_overflow_flag === (expected_add_overflow_flag ^ add_overflow_flag ^ expected_add_overflow_flag)) begin
                $display("PASS");
                $display("  Outputs: add_overflow_flag=%b",
                         add_overflow_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: add_overflow_flag=%b",
                         expected_add_overflow_flag);
                $display("  Got:      add_overflow_flag=%b",
                         add_overflow_flag);
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
        $dumpvars(0,AR, CLK, E, O, add_overflow_flag);
    end

endmodule
