`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] ctrl;
    reg [3:0] in;
    wire [1:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: Ctrl=00, Input bit 3 high (Standard Priority)");
            ctrl = 2'b00;
            in = 4'b1000;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Ctrl=00, Input bit 2 high");
            ctrl = 2'b00;
            in = 4'b0100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Ctrl=00, Input bits 3 and 2 high (Priority check)");
            ctrl = 2'b00;
            in = 4'b1100;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Ctrl=00, Input bit 0 high");
            ctrl = 2'b00;
            in = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Ctrl=01, Masking Bit 3 (Priority Shift)");

            ctrl = 2'b01;
            in = 4'b1100;
            #1;

            check_outputs(2'b10);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Ctrl=01, Input bit 1 high");
            ctrl = 2'b01;
            in = 4'b0010;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Ctrl=10, Masking Bits 3 and 2");
            ctrl = 2'b10;
            in = 4'b1110;
            #1;

            check_outputs(2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Ctrl=10, Input bit 0 high");
            ctrl = 2'b10;
            in = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Ctrl=11, Masking Bits 3, 2, and 1");
            ctrl = 2'b11;
            in = 4'b1111;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Ctrl=11, Only Bit 0 considered");
            ctrl = 2'b11;
            in = 4'b0001;
            #1;

            check_outputs(2'b00);
        end
        endtask

    task testcase011;

        begin
            $display("Testcase 011: Ctrl=00, All bits active");
            ctrl = 2'b00;
            in = 4'b1111;
            #1;

            check_outputs(2'b11);
        end
        endtask

    task testcase012;

        begin
            $display("Testcase 012: Ctrl=01, Multiple low bits active");
            ctrl = 2'b01;
            in = 4'b0011;
            #1;

            check_outputs(2'b01);
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
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [1:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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

endmodule
