`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] A;
    reg D;
    reg WCLK;
    reg WE;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .D(D),
        .WCLK(WCLK),
        .WE(WE),
        .O(O)
    );

        task reset_dut;

        begin
            A = 0;
            D = 0;
            WCLK = 0;
            WE = 0;
            #CLK_PERIOD;
        end
        endtask
    task pulse_clk;

        begin
            # (CLK_PERIOD/2) WCLK = 1;
            # (CLK_PERIOD/2) WCLK = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Testcase 001: Write 1 to Address 0...");
            reset_dut();
            A = 9'd0;
            D = 1'b1;
            WE = 1'b1;
            pulse_clk();

            WE = 1'b0;
            A = 9'd0;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Write 0 to Address 511...");
            reset_dut();

            A = 9'd511; D = 1'b1; WE = 1'b1;
            pulse_clk();


            D = 1'b0;
            pulse_clk();

            WE = 1'b0;
            A = 9'd511;
            #5;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Verify WE=0 prevents writing...");
            reset_dut();

            A = 9'd100; D = 1'b1; WE = 1'b1;
            pulse_clk();


            D = 1'b0;
            WE = 1'b0;
            pulse_clk();


            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Check that writing to one address doesn't affect another...");
            reset_dut();

            A = 9'd5; D = 1'b1; WE = 1'b1;
            pulse_clk();


            A = 9'd6; D = 1'b0; WE = 1'b1;
            pulse_clk();


            WE = 1'b0;
            A = 9'd5;
            #5;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data toggle at Address 256...");
            reset_dut();
            A = 9'd256; WE = 1'b1;

            D = 1'b1; pulse_clk();
            D = 1'b0; pulse_clk();
            D = 1'b1; pulse_clk();

            WE = 1'b0;
            #5;
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
        input expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
        $dumpvars(0,A, D, WCLK, WE, O);
    end

endmodule
