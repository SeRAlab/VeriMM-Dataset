`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] iDIG;
    wire [6:0] oSEG;
    wire oSEG_DP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .iDIG(iDIG),
        .oSEG(oSEG),
        .oSEG_DP(oSEG_DP)
    );
    task testcase001;

        begin
            $display("Test Case 001: Input 0");
            test_num = test_num + 1;
            iDIG = 4'h0;
            #10;
            #1;

            check_outputs(7'b0111111, 1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Input 1");
            test_num = test_num + 1;
            iDIG = 4'h1;
            #10;
            #1;

            check_outputs(7'b0000110, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Input 2");
            test_num = test_num + 1;
            iDIG = 4'h2;
            #10;
            #1;

            check_outputs(7'b1011011, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Input 3");
            test_num = test_num + 1;
            iDIG = 4'h3;
            #10;
            #1;

            check_outputs(7'b1001111, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Input 4");
            test_num = test_num + 1;
            iDIG = 4'h4;
            #10;
            #1;

            check_outputs(7'b1100110, 1'b1);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Input 5");
            test_num = test_num + 1;
            iDIG = 4'h5;
            #10;
            #1;

            check_outputs(7'b1101101, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Input 6");
            test_num = test_num + 1;
            iDIG = 4'h6;
            #10;
            #1;

            check_outputs(7'b1111101, 1'b1);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Input 7");
            test_num = test_num + 1;
            iDIG = 4'h7;
            #10;
            #1;

            check_outputs(7'b0000111, 1'b1);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Input 8");
            test_num = test_num + 1;
            iDIG = 4'h8;
            #10;
            #1;

            check_outputs(7'b1111111, 1'b1);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Input 9");
            test_num = test_num + 1;
            iDIG = 4'h9;
            #10;
            #1;

            check_outputs(7'b1101111, 1'b1);
        end
        endtask

    task testcase011;

        begin
            $display("Test Case 011: Input A");
            test_num = test_num + 1;
            iDIG = 4'hA;
            #10;
            #1;

            check_outputs(7'b1110111, 1'b1);
        end
        endtask

    task testcase012;

        begin
            $display("Test Case 012: Input B");
            test_num = test_num + 1;
            iDIG = 4'hB;
            #10;
            #1;

            check_outputs(7'b1111100, 1'b1);
        end
        endtask

    task testcase013;

        begin
            $display("Test Case 013: Input C");
            test_num = test_num + 1;
            iDIG = 4'hC;
            #10;
            #1;

            check_outputs(7'b0111001, 1'b1);
        end
        endtask

    task testcase014;

        begin
            $display("Test Case 014: Input D");
            test_num = test_num + 1;
            iDIG = 4'hD;
            #10;
            #1;

            check_outputs(7'b1011110, 1'b1);
        end
        endtask

    task testcase015;

        begin
            $display("Test Case 015: Input E");
            test_num = test_num + 1;
            iDIG = 4'hE;
            #10;
            #1;

            check_outputs(7'b1111001, 1'b1);
        end
        endtask

    task testcase016;

        begin
            $display("Test Case 016: Input F");
            test_num = test_num + 1;
            iDIG = 4'hF;
            #10;
            #1;

            check_outputs(7'b1110001, 1'b1);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [6:0] expected_oSEG;
        input expected_oSEG_DP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oSEG === (expected_oSEG ^ oSEG ^ expected_oSEG) &&
                expected_oSEG_DP === (expected_oSEG_DP ^ oSEG_DP ^ expected_oSEG_DP)) begin
                $display("PASS");
                $display("  Outputs: oSEG=%h, oSEG_DP=%b",
                         oSEG, oSEG_DP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oSEG=%h, oSEG_DP=%b",
                         expected_oSEG, expected_oSEG_DP);
                $display("  Got:      oSEG=%h, oSEG_DP=%b",
                         oSEG, oSEG_DP);
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
