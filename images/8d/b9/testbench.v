`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] key;
    wire [27:0] c0x;
    wire [27:0] d0x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .key(key),
        .c0x(c0x),
        .d0x(d0x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            key = 64'h0000000000000000;
            #1;

            check_outputs(28'h0000000, 28'h0000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            key = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(28'hFFFFFFF, 28'hFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard DES Key 1", test_num);
            key = 64'h133457799BBCDFF1;
            #1;

            check_outputs(28'hF0CCAA0, 28'hA30A303);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Standard DES Key 2", test_num);
            key = 64'h0123456789ABCDEF;
            #1;

            check_outputs(28'hF000FF0, 28'h8E8E8E0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Parity Bits Only (Discarded)", test_num);
            key = 64'h0101010101010101;
            #1;

            check_outputs(28'h0000000, 28'h0000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits", test_num);
            key = 64'hAAAAAAAAAAAAAAAA;

            #1;


            check_outputs(28'h5555555, 28'h5555555);
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
        input [27:0] expected_c0x;
        input [27:0] expected_d0x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c0x === (expected_c0x ^ c0x ^ expected_c0x) &&
                expected_d0x === (expected_d0x ^ d0x ^ expected_d0x)) begin
                $display("PASS");
                $display("  Outputs: c0x=%h, d0x=%h",
                         c0x, d0x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c0x=%h, d0x=%h",
                         expected_c0x, expected_d0x);
                $display("  Got:      c0x=%h, d0x=%h",
                         c0x, d0x);
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
