`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire out;

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
            $display("Testcase 001: All bits zero");
            in = 16'h0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All bits one");
            in = 16'hFFFF;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: LSB only set");
            in = 16'h0001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: MSB only set");
            in = 16'h8000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Middle bit set (bit 8)");
            in = 16'h0100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Alternating bits (AAAA)");
            in = 16'hAAAA;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Alternating bits (5555)");
            in = 16'h5555;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: All bits set except LSB");
            in = 16'hFFFE;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: Only one bit high at bit 4");
            in = 16'h0010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: Only one bit high at bit 12");
            in = 16'h1000;
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
