`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] m;
    reg [7:0] n;
    wire [7:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .m(m),
        .n(n),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            m = 8'h00;
            n = 8'h00;
            $display("Test Case 001: All zeros");
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            m = 8'hFF;
            n = 8'hFF;
            $display("Test Case 002: All ones");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            m = 8'hAA;
            n = 8'h55;
            $display("Test Case 003: Complementary patterns (AA | 55)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            m = 8'hF0;
            n = 8'h0F;
            $display("Test Case 004: Nibble swap (F0 | 0F)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            m = 8'hA5;
            n = 8'h00;
            $display("Test Case 005: Input m with zero (A5 | 00)");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            m = 8'h00;
            n = 8'h5A;
            $display("Test Case 006: Input n with zero (00 | 5A)");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            m = 8'h55;
            n = 8'hFF;
            $display("Test Case 007: Input m with all ones (55 | FF)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            m = 8'h12;
            n = 8'h48;
            $display("Test Case 008: Disjoint bits (12 | 48)");
            #1;

            check_outputs(8'h5A);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            m = 8'hC3;
            n = 8'h3C;
            $display("Test Case 009: Partially overlapping patterns (C3 | 3C)");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            m = 8'h81;
            n = 8'h81;
            $display("Test Case 010: Identical inputs (81 | 81)");
            #1;

            check_outputs(8'h81);
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
        input [7:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
