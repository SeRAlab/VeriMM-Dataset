`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    wire [63:0] b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: All Zeros", test_num);
            a = 64'h00000000_00000000;
            #1;

            check_outputs(expected_result(a));
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: All Ones", test_num);
            a = 64'hFFFFFFFF_FFFFFFFF;
            #1;

            check_outputs(expected_result(a));
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Alternating Bits (Inverted Halves)", test_num);
            a = 64'hAAAAAAAA_55555555;
            #1;

            check_outputs(expected_result(a));
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Identical Halves", test_num);
            a = 64'h12345678_12345678;
            #1;

            check_outputs(expected_result(a));
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Bitmask Check", test_num);
            a = 64'hFFFF0000_0000FFFF;
            #1;

            check_outputs(expected_result(a));
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Arbitrary Signed Values", test_num);
            a = 64'hDEADBEEF_CAFEBABE;
            #1;

            check_outputs(expected_result(a));
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Single Bit Interactions", test_num);
            a = 64'h00000001_80000000;
            #1;

            check_outputs(expected_result(a));
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
        input [63:0] expected_b;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b === (expected_b ^ b ^ expected_b)) begin
                $display("PASS");
                $display("  Outputs: b=%h",
                         b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b=%h",
                         expected_b);
                $display("  Got:      b=%h",
                         b);
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
