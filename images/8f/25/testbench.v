`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg input_1;
    reg input_2;
    wire and_gate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input_1(input_1),
        .input_2(input_2),
        .and_gate(and_gate)
    );

    // Clock generation (10ns period)
    initial begin
        input_1 = 0;
        forever #5 input_1 = ~input_1;
    end

        task reset_dut;

        begin


            input_2 = 0;
            @(negedge input_1);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;

            input_2 = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            @(posedge input_1);
            input_2 = 0;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            @(negedge input_1);
            input_2 = 1;
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            @(posedge input_1);
            input_2 = 1;
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            @(posedge input_1);
            input_2 = 0;
            #1;
            input_2 = 1;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            input_2 = 1;
            @(posedge input_1);
            @(negedge input_1);
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
        input expected_and_gate;
        begin
            if (expected_and_gate === (expected_and_gate ^ and_gate ^ expected_and_gate)) begin
                $display("PASS");
                $display("  Outputs: and_gate=%b",
                         and_gate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: and_gate=%b",
                         expected_and_gate);
                $display("  Got:      and_gate=%b",
                         and_gate);
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
        $dumpvars(0,input_1, input_2, and_gate);
    end

endmodule
