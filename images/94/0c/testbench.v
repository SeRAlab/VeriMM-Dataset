`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [5:0] A;
    reg D;
    reg WCLK;
    reg WE;
    reg [2:0] WSEL;
    wire [7:0] O;

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
        .WSEL(WSEL),
        .O(O)
    );

        task reset_dut;

        begin
            A = 0;
            D = 0;
            WCLK = 0;
            WE = 0;
            WSEL = 0;
            #10;
        end
        endtask
    task pulse_wclk;

        begin
            #5 WCLK = 1;
            #5 WCLK = 0;
        end
        endtask

    task testcase001;

        begin
            $display("Running Testcase 001: Basic single-bit write...");
            reset_dut();
            A = 6'd1;
            WSEL = 3'd0;
            D = 1'b1;
            WE = 1'b1;
            pulse_wclk();
            WE = 1'b0;
            #5 #1;
 check_outputs(8'h01);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Accumulate bits in one word...");
            reset_dut();
            A = 6'd2;
            WE = 1'b1;


            WSEL = 3'd0; D = 1'b1;
            pulse_wclk();


            WSEL = 3'd7; D = 1'b1;
            pulse_wclk();

            WE = 1'b0;
            #5 #1;
 check_outputs(8'h81);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Overwrite/Clear bit...");
            reset_dut();
            A = 6'd10;
            WE = 1'b1;


            WSEL = 3'd4; D = 1'b1;
            pulse_wclk();


            WSEL = 3'd4; D = 1'b0;
            pulse_wclk();

            WE = 1'b0;
            #5 #1;
 check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Write Enable check...");
            reset_dut();
            A = 6'd15;


            WE = 1'b1; WSEL = 3'd2; D = 1'b1;
            pulse_wclk();


            WE = 1'b0; WSEL = 3'd3; D = 1'b1;
            pulse_wclk();

            #5 #1;
 check_outputs(8'h04);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Max address boundary check...");
            reset_dut();
            A = 6'd63;
            WE = 1'b1;
            WSEL = 3'd5;
            D = 1'b1;
            pulse_wclk();
            WE = 1'b0;
            #5 #1;
 check_outputs(8'h20);
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
        input [7:0] expected_O;
        begin
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%h",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%h",
                         expected_O);
                $display("  Got:      O=%h",
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
        $dumpvars(0,A, D, WCLK, WE, WSEL, O);
    end

endmodule
