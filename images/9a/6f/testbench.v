`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire [63:0] andAB;
    wire [63:0] orAB;
    wire [63:0] xorAB;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .andAB(andAB),
        .orAB(orAB),
        .xorAB(xorAB)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: All Zeros");
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(64'h0, 64'h0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: All Ones");
            A = 64'hFFFFFFFFFFFFFFFF;
            B = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF, 64'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Complementary Bit Patterns (A=AAAA..., B=5555...)");
            A = 64'hAAAAAAAAAAAAAAAA;
            B = 64'h5555555555555555;
            #1;

            check_outputs(64'h0, 64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Alternating Nibbles");
            A = 64'hF0F0F0F0F0F0F0F0;
            B = 64'h0F0F0F0F0F0F0F0F;
            #1;

            check_outputs(64'h0, 64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Random Hex Pattern 1");
            A = 64'h123456789ABCDEF0;
            B = 64'hFEDCBA9876543210;



            #1;




            check_outputs(A & B, A | B, A ^ B);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case 006: Single Bit Check (LSB and MSB)");
            A = 64'h0000000000000001;
            B = 64'h8000000000000000;
            #1;

            check_outputs(64'h0, 64'h8000000000000001, 64'h8000000000000001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case 007: Overlapping Bits");
            A = 64'hFFFFFFFF00000000;
            B = 64'h00000000FFFFFFFF;
            #1;

            check_outputs(64'h0, 64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case 008: Dense Overlap");
            A = 64'hCCCCCCCCCCCCCCCC;
            B = 64'h3333333333333333;
            #1;

            check_outputs(64'h0, 64'hFFFFFFFFFFFFFFFF, 64'hFFFFFFFFFFFFFFFF);
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
        input [63:0] expected_andAB;
        input [63:0] expected_orAB;
        input [63:0] expected_xorAB;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_andAB === (expected_andAB ^ andAB ^ expected_andAB) &&
                expected_orAB === (expected_orAB ^ orAB ^ expected_orAB) &&
                expected_xorAB === (expected_xorAB ^ xorAB ^ expected_xorAB)) begin
                $display("PASS");
                $display("  Outputs: andAB=%h, orAB=%h, xorAB=%h",
                         andAB, orAB, xorAB);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: andAB=%h, orAB=%h, xorAB=%h",
                         expected_andAB, expected_orAB, expected_xorAB);
                $display("  Got:      andAB=%h, orAB=%h, xorAB=%h",
                         andAB, orAB, xorAB);
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
