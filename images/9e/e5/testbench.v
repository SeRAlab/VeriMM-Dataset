`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        $display("Test Case 001: Zero input");
        in = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        $display("Test Case 002: Max positive value (0x7F)");
        in = 8'h7F;
        #1;

        check_outputs(16'h007F);
    end
        endtask

    task testcase003;

    begin
        $display("Test Case 003: Min negative value (0x80)");
        in = 8'h80;
        #1;

        check_outputs(16'hFF80);
    end
        endtask

    task testcase004;

    begin
        $display("Test Case 004: Minus one (0xFF)");
        in = 8'hFF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        $display("Test Case 005: Positive value with middle bits set (0x45)");
        in = 8'h45;
        #1;

        check_outputs(16'h0045);
    end
        endtask

    task testcase006;

    begin
        $display("Test Case 006: Negative value with middle bits set (0xA3)");
        in = 8'hA3;
        #1;

        check_outputs(16'hFFA3);
    end
        endtask

    task testcase007;

    begin
        $display("Test Case 007: Positive value (0x01)");
        in = 8'h01;
        #1;

        check_outputs(16'h0001);
    end
        endtask

    task testcase008;

    begin
        $display("Test Case 008: Negative value (0xFE)");
        in = 8'hFE;
        #1;

        check_outputs(16'hFFFE);
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
        input [15:0] expected_out;
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
