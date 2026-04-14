`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg IN;
    reg Reset;
    wire OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .IN(IN),
        .Reset(Reset),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        IN = 0;
        forever #5 IN = ~IN;
    end

        task reset_dut;

        begin
            Reset = 1;
            @(posedge IN);
            #1;
            Reset = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying synchronous reset to LOW", test_num);
            reset_dut();
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying toggle after 1 clock cycle (0 -> 1)", test_num);
            reset_dut();
            @(posedge IN);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Verifying toggle after 2 clock cycles (0 -> 1 -> 0)", test_num);
            reset_dut();
            @(posedge IN);
            @(posedge IN);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Verifying toggle after 3 clock cycles (0 -> 1 -> 0 -> 1)", test_num);
            reset_dut();
            @(posedge IN);
            @(posedge IN);
            @(posedge IN);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Verifying synchronous reset while output is HIGH", test_num);
            reset_dut();
            @(posedge IN);
            #1;

            Reset = 1;
            @(posedge IN);
            #1;
            Reset = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Verifying output stays LOW when Reset is held", test_num);
            reset_dut();
            Reset = 1;
            repeat (4) @(posedge IN);
            #1;
            #1;

            check_outputs(1'b0);
            Reset = 0;
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
        input expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%b",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%b",
                         expected_OUT);
                $display("  Got:      OUT=%b",
                         OUT);
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
        $dumpvars(0,IN, Reset, OUT);
    end

endmodule
