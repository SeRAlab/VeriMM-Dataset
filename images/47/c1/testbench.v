`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] out;

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
            $display("Testcase 001: All zeros (00h)");
            in = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones (FFh)");
            in = 8'hFF;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Alternating bits (AAh -> 55h)");
            in = 8'hAA;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating bits (55h -> AAh)");
            in = 8'h55;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: High nibble set (F0h -> 0Fh)");
            in = 8'hF0;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Low nibble set (0Fh -> F0h)");
            in = 8'h0F;
            #1;

            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single bit LSB (01h -> 80h)");
            in = 8'h01;
            #1;

            check_outputs(8'h80);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: Single bit MSB (80h -> 01h)");
            in = 8'h80;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Symmetric pattern (C3h -> C3h)");
            in = 8'hC3;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Complex pattern (4Bh -> D2h)");
            in = 8'h4B;
            #1;

            check_outputs(8'hD2);
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
        input [7:0] expected_out;
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
