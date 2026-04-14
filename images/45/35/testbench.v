`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] mul_s1;
    reg [31:0] mul_s2;
    wire [63:0] mul_result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .mul_s1(mul_s1),
        .mul_s2(mul_s2),
        .mul_result(mul_result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Multiplication", test_num);
            mul_s1 = 32'h0000_0000;
            mul_s2 = 32'h0000_0000;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication by Zero", test_num);
            mul_s1 = 32'hFFFF_FFFF;
            mul_s2 = 32'h0000_0000;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication by One", test_num);
            mul_s1 = 32'hABCD_EF12;
            mul_s2 = 32'h0000_0001;
            #1;

            check_outputs(64'h0000_0000_ABCD_EF12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Small Multiplication", test_num);
            mul_s1 = 32'd100;
            mul_s2 = 32'd250;
            #1;

            check_outputs(64'd25000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum 32-bit Unsigned Values", test_num);
            mul_s1 = 32'hFFFF_FFFF;
            mul_s2 = 32'hFFFF_FFFF;

            #1;


            check_outputs(64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 Multiplication", test_num);
            mul_s1 = 32'h0001_0000;
            mul_s2 = 32'h0001_0000;
            #1;

            check_outputs(64'h0000_0001_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed High and Low Bits", test_num);
            mul_s1 = 32'h1234_5678;
            mul_s2 = 32'h8765_4321;
            #1;

            check_outputs(64'h09A0_A1F0_8970_5E78);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            mul_s1 = 32'hAAAA_AAAA;
            mul_s2 = 32'h5555_5555;
            #1;

            check_outputs(64'h38E3_8E38_71C7_1C72);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Value times Small Value", test_num);
            mul_s1 = 32'hFFFF_FFFF;
            mul_s2 = 32'h0000_0002;
            #1;

            check_outputs(64'h0000_0001_FFFE_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Prime Number Multiplication", test_num);
            mul_s1 = 32'd104729;
            mul_s2 = 32'd1299709;
            #1;

            check_outputs(64'd136117223861);
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
        input [63:0] expected_mul_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mul_result === (expected_mul_result ^ mul_result ^ expected_mul_result)) begin
                $display("PASS");
                $display("  Outputs: mul_result=%h",
                         mul_result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mul_result=%h",
                         expected_mul_result);
                $display("  Got:      mul_result=%h",
                         mul_result);
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
