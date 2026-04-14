`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] c;
    wire [6:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c(c),
        .out(out)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros");
            test_num = 1;
            c = 7'h00;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: LSB only");
            test_num = 2;
            c = 7'h01;
            #1;

            check_outputs(7'h02);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Middle bit shift");
            test_num = 3;
            c = 7'h08;
            #1;

            check_outputs(7'h10);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Bit 5 shift to MSB");
            test_num = 4;
            c = 7'h20;
            #1;

            check_outputs(7'h40);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: MSB lost during shift");
            test_num = 5;
            c = 7'h40;
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: All ones");
            test_num = 6;
            c = 7'h7F;
            #1;

            check_outputs(7'h7E);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating pattern 1");
            test_num = 7;
            c = 7'h55;
            #1;

            check_outputs(7'h2A);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Alternating pattern 2");
            test_num = 8;
            c = 7'h2A;
            #1;

            check_outputs(7'h54);
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
        input [6:0] expected_out;
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
