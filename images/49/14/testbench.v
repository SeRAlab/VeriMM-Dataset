`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] a;
    reg [5:0] b;
    wire [5:0] s2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .s2(s2)
    );
    task testcase001;

        begin
            $display("Testcase 001: All zeros (00 ^ 00)");
            a = 6'h00;
            b = 6'h00;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: All ones (3F ^ 3F)");
            a = 6'h3F;
            b = 6'h3F;
            #1;

            check_outputs(6'h00);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: All ones vs All zeros (3F ^ 00)");
            a = 6'h3F;
            b = 6'h00;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Alternating bits pattern (2A ^ 15)");

            a = 6'h2A;
            b = 6'h15;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Mixed bits (12 ^ 34)");

            a = 6'h12;
            b = 6'h34;
            #1;

            check_outputs(6'h26);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Lower bits vs Upper bits (07 ^ 38)");

            a = 6'h07;
            b = 6'h38;
            #1;

            check_outputs(6'h3F);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Single bit toggling (01 ^ 00)");
            a = 6'h01;
            b = 6'h00;
            #1;

            check_outputs(6'h01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: MSB toggling (20 ^ 00)");
            a = 6'h20;
            b = 6'h00;
            #1;

            check_outputs(6'h20);
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
        input [5:0] expected_s2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s2 === (expected_s2 ^ s2 ^ expected_s2)) begin
                $display("PASS");
                $display("  Outputs: s2=%h",
                         s2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s2=%h",
                         expected_s2);
                $display("  Got:      s2=%h",
                         s2);
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
