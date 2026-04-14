`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BCD;
    wire [6:0] s7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BCD(BCD),
        .s7(s7)
    );
    task testcase001;

        begin
            test_num = 1;
            BCD = 4'd0;
            $display("Test Case %0d: BCD = %d (Digit 0)", test_num, BCD);
            #1;

            check_outputs(7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            BCD = 4'd1;
            $display("Test Case %0d: BCD = %d (Digit 1)", test_num, BCD);
            #1;

            check_outputs(7'h06);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            BCD = 4'd2;
            $display("Test Case %0d: BCD = %d (Digit 2)", test_num, BCD);
            #1;

            check_outputs(7'h5b);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            BCD = 4'd3;
            $display("Test Case %0d: BCD = %d (Digit 3)", test_num, BCD);
            #1;

            check_outputs(7'h4f);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            BCD = 4'd4;
            $display("Test Case %0d: BCD = %d (Digit 4)", test_num, BCD);
            #1;

            check_outputs(7'h66);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            BCD = 4'd5;
            $display("Test Case %0d: BCD = %d (Digit 5)", test_num, BCD);
            #1;

            check_outputs(7'h6d);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            BCD = 4'd6;
            $display("Test Case %0d: BCD = %d (Digit 6)", test_num, BCD);
            #1;

            check_outputs(7'h7d);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            BCD = 4'd7;
            $display("Test Case %0d: BCD = %d (Digit 7)", test_num, BCD);
            #1;

            check_outputs(7'h07);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            BCD = 4'd8;
            $display("Test Case %0d: BCD = %d (Digit 8)", test_num, BCD);
            #1;

            check_outputs(7'h7f);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            BCD = 4'd9;
            $display("Test Case %0d: BCD = %d (Digit 9)", test_num, BCD);
            #1;

            check_outputs(7'h6f);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            BCD = 4'd10;
            $display("Test Case %0d: BCD = %d (Invalid)", test_num, BCD);
            #1;

            check_outputs(7'h00);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            BCD = 4'd15;
            $display("Test Case %0d: BCD = %d (Invalid)", test_num, BCD);
            #1;

            check_outputs(7'h00);
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
        input [6:0] expected_s7;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s7 === (expected_s7 ^ s7 ^ expected_s7)) begin
                $display("PASS");
                $display("  Outputs: s7=%h",
                         s7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s7=%h",
                         expected_s7);
                $display("  Got:      s7=%h",
                         s7);
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
