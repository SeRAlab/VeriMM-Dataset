`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg vdd;
    wire reset;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .vdd(vdd),
        .reset(reset)
    );

    // Clock generation (10ns period)
    initial begin
        vdd = 0;
        forever #5 vdd = ~vdd;
    end

        task reset_dut;

        begin



            @(posedge vdd);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset is LOW during stabilization period", test_num);
            reset_dut();


            #30;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset is HIGH after stabilization delay completes", test_num);
            reset_dut();


            #200;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verifying Reset remains HIGH during steady state", test_num);
            reset_dut();


            #500;
            #1;

            check_outputs(1'b1);
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
        input expected_reset;
        begin
            if (expected_reset === (expected_reset ^ reset ^ expected_reset)) begin
                $display("PASS");
                $display("  Outputs: reset=%b",
                         reset);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: reset=%b",
                         expected_reset);
                $display("  Got:      reset=%b",
                         reset);
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
        $dumpvars(0,vdd, reset);
    end

endmodule
