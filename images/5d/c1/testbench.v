`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] in_signal;
    wire [15:0] out_signal1;
    wire [15:0] out_signal2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_signal(in_signal),
        .out_signal1(out_signal1),
        .out_signal2(out_signal2)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            in_signal = 32'h0000_0000;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            in_signal = 32'hFFFF_FFFF;
            #1;

            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Sequence", test_num);
            in_signal = 32'h1234_5678;
            #1;

            check_outputs(16'h5678, 16'h1234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reverse Hex Sequence", test_num);
            in_signal = 32'h89AB_CDEF;
            #1;

            check_outputs(16'hCDEF, 16'h89AB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits A-5", test_num);
            in_signal = 32'hAAAA_5555;
            #1;

            check_outputs(16'h5555, 16'hAAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits 5-A", test_num);
            in_signal = 32'h5555_AAAA;
            #1;

            check_outputs(16'hAAAA, 16'h5555);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Upper Half Zero", test_num);
            in_signal = 32'h0000_ABCD;
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Lower Half Zero", test_num);
            in_signal = 32'hFEDC_0000;
            #1;

            check_outputs(16'h0000, 16'hFEDC);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Boundary (LSB/MSB)", test_num);
            in_signal = 32'h8000_0001;
            #1;

            check_outputs(16'h0001, 16'h8000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Middle Boundary Split", test_num);
            in_signal = 32'h0001_8000;
            #1;

            check_outputs(16'h8000, 16'h0001);
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
        input [15:0] expected_out_signal1;
        input [15:0] expected_out_signal2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_signal1 === (expected_out_signal1 ^ out_signal1 ^ expected_out_signal1) &&
                expected_out_signal2 === (expected_out_signal2 ^ out_signal2 ^ expected_out_signal2)) begin
                $display("PASS");
                $display("  Outputs: out_signal1=%h, out_signal2=%h",
                         out_signal1, out_signal2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_signal1=%h, out_signal2=%h",
                         expected_out_signal1, expected_out_signal2);
                $display("  Got:      out_signal1=%h, out_signal2=%h",
                         out_signal1, out_signal2);
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
