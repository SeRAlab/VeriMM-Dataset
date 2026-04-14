`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg AC;
    reg CLK;
    wire DC;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AC(AC),
        .CLK(CLK),
        .DC(DC)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            AC = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            AC = 1'b1;
            @(posedge CLK);
            #2;
            $display("Testcase 001: AC positive cycle (1)");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            AC = 1'b0;
            @(posedge CLK);
            #2;
            $display("Testcase 002: AC negative cycle (0)");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            AC = 1'b1;
            @(posedge CLK);
            #2;
            AC = 1'b0;
            @(posedge CLK);
            #2;
            $display("Testcase 003: Transition High to Low");
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            AC = 1'b0;
            @(posedge CLK);
            #2;
            AC = 1'b1;
            @(posedge CLK);
            #2;
            $display("Testcase 004: Transition Low to High");
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            AC = 1'b1;
            repeat(3) @(posedge CLK);
            #2;
            $display("Testcase 005: Sustained High AC");
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
        input expected_DC;
        begin
            if (expected_DC === (expected_DC ^ DC ^ expected_DC)) begin
                $display("PASS");
                $display("  Outputs: DC=%b",
                         DC);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DC=%b",
                         expected_DC);
                $display("  Got:      DC=%b",
                         DC);
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
        $dumpvars(0,AC, CLK, DC);
    end

endmodule
