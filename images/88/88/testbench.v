`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RSTN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .RSTN(RSTN)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RSTN = 0;
            @(posedge CLK);
            #2;
            RSTN = 1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Reset State Check");
            reset_dut();

            #1;


            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Increment to 1");
            reset_dut();
            @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Check 'now' signal at count 2");
            reset_dut();
            repeat(2) @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd2, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Maximum Count Check (5)");
            reset_dut();
            repeat(5) @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd5, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Rollover Check (5 to 0)");
            reset_dut();
            repeat(6) @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Multiple Wraps (14 cycles)");
            reset_dut();

            repeat(14) @(posedge CLK);
            #2;
            #1;

            check_outputs(3'd2, 1'b0);
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
        begin
            if () begin
                $display("PASS");
                $display("  Outputs: ",
                         );
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ",
                         );
                $display("  Got:      ",
                         );
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
        $dumpvars(0,CLK, RSTN);
    end

endmodule
