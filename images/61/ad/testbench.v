`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    wire [15:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 16'h0000;
        b = 16'h0000;
        c = 16'h0000;
        $display("Test %0d: All zeros", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 16'hFFFF;
        b = 16'hFFFF;
        c = 16'hFFFF;
        $display("Test %0d: All ones", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 16'hAAAA;
        b = 16'h5555;
        c = 16'h0000;
        $display("Test %0d: Complementary patterns with zero", test_num);
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 16'h1234;
        b = 16'h1234;
        c = 16'hABCD;
        $display("Test %0d: Identity check (a ^ a ^ c)", test_num);
        #1;

        check_outputs(16'hABCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 16'hF0F0;
        b = 16'h0F0F;
        c = 16'hFFFF;
        $display("Test %0d: Result resulting in zero", test_num);
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 16'h1234;
        b = 16'h5678;
        c = 16'h9ABC;

        $display("Test %0d: Arbitrary values", test_num);
        #1;

        check_outputs(16'hDEF0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 16'h0001;
        b = 16'h0010;
        c = 16'h0100;
        $display("Test %0d: Individual bits set", test_num);
        #1;

        check_outputs(16'h0111);
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
