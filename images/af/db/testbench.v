`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 16'h0000;
        B = 16'h0000;
        $display("Test Case %0d: Zero addition (0 + 0)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 16'h1234;
        B = 16'h4321;
        $display("Test Case %0d: Simple addition without carry (1234 + 4321)", test_num);
        #1;

        check_outputs(16'h5555);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 16'h000F;
        B = 16'h0001;
        $display("Test Case %0d: Carry propagation within lower nibble (F + 1)", test_num);
        #1;

        check_outputs(16'h0010);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 16'hFFFF;
        B = 16'h0000;
        $display("Test Case %0d: Adding zero to maximum value", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 16'hFFFF;
        B = 16'h0001;
        $display("Test Case %0d: Full 16-bit overflow (FFFF + 1)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 16'hAAAA;
        B = 16'h5555;
        $display("Test Case %0d: Alternating bit patterns (AAAA + 5555)", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 16'h1234;
        B = 16'hABCD;
        $display("Test Case %0d: Random pattern addition (1234 + ABCD)", test_num);
        #1;

        check_outputs(16'hBE01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 16'h7FFF;
        B = 16'h7FFF;
        $display("Test Case %0d: Near overflow (7FFF + 7FFF)", test_num);
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 16'h8000;
        B = 16'h8000;
        $display("Test Case %0d: MSB addition leading to zero (8000 + 8000)", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 16'hDEAD;
        B = 16'hBEEF;
        $display("Test Case %0d: Word addition with multiple carries (DEAD + BEEF)", test_num);
        #1;

        check_outputs(16'h9D9C);
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
        input [15:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
