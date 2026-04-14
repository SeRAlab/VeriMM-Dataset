`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [1:0] factor;
    wire [63:0] B;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .factor(factor),
        .B(B)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Factor 00 (No shift)", test_num);
        A = 64'hFEDCBA9876543210;
        factor = 2'b00;
        #1;

        check_outputs(64'hFEDCBA9876543210);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Factor 01 (Shift 4 bits)", test_num);
        A = 64'hFEDCBA9876543210;
        factor = 2'b01;
        #1;

        check_outputs(64'hEDCBA98765432100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Factor 10 (Shift 8 bits)", test_num);
        A = 64'hFEDCBA9876543210;
        factor = 2'b10;
        #1;

        check_outputs(64'hDCBA987654321000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Factor 11 (Shift 12 bits)", test_num);
        A = 64'hFEDCBA9876543210;
        factor = 2'b11;
        #1;

        check_outputs(64'hCBA9876543210000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: All ones - No shift", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        factor = 2'b00;
        #1;

        check_outputs(64'hFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: All ones - Shift 12 bits (Check zero padding)", test_num);
        A = 64'hFFFFFFFFFFFFFFFF;
        factor = 2'b11;
        #1;

        check_outputs(64'hFFFFFFFFFFFFF000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Shifting out high-order bits", test_num);
        A = 64'h000000000000000F;
        factor = 2'b11;
        #1;

        check_outputs(64'h000000000000F000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: All zeros input", test_num);
        A = 64'h0000000000000000;
        factor = 2'b10;
        #1;

        check_outputs(64'h0000000000000000);
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
        input [63:0] expected_B;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_B === (expected_B ^ B ^ expected_B)) begin
                $display("PASS");
                $display("  Outputs: B=%h",
                         B);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: B=%h",
                         expected_B);
                $display("  Got:      B=%h",
                         B);
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
