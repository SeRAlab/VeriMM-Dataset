`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] LEFT16;
    reg [31:0] RIGHT16;
    wire [31:0] LEFT_SWAP;
    wire [31:0] RIGHT_SWAP;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LEFT16(LEFT16),
        .RIGHT16(RIGHT16),
        .LEFT_SWAP(LEFT_SWAP),
        .RIGHT_SWAP(RIGHT_SWAP)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic Swapping", test_num);
            LEFT16 = 32'h12345678;
            RIGHT16 = 32'h87654321;
            #1;

            check_outputs(32'h87654321, 32'h12345678);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            LEFT16 = 32'h00000000;
            RIGHT16 = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Values", test_num);
            LEFT16 = 32'hFFFFFFFF;
            RIGHT16 = 32'h00000000;
            #1;

            check_outputs(32'h00000000, 32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bit Patterns", test_num);
            LEFT16 = 32'hAAAAAAAA;
            RIGHT16 = 32'h55555555;
            #1;

            check_outputs(32'h55555555, 32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Values", test_num);
            LEFT16 = 32'hA5A5A5A5;
            RIGHT16 = 32'hA5A5A5A5;
            #1;

            check_outputs(32'hA5A5A5A5, 32'hA5A5A5A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hex Words", test_num);
            LEFT16 = 32'hDEADBEEF;
            RIGHT16 = 32'hCAFEBABE;
            #1;

            check_outputs(32'hCAFEBABE, 32'hDEADBEEF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Shift", test_num);
            LEFT16 = 32'h00000001;
            RIGHT16 = 32'h80000000;
            #1;

            check_outputs(32'h80000000, 32'h00000001);
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
        input [31:0] expected_LEFT_SWAP;
        input [31:0] expected_RIGHT_SWAP;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LEFT_SWAP === (expected_LEFT_SWAP ^ LEFT_SWAP ^ expected_LEFT_SWAP) &&
                expected_RIGHT_SWAP === (expected_RIGHT_SWAP ^ RIGHT_SWAP ^ expected_RIGHT_SWAP)) begin
                $display("PASS");
                $display("  Outputs: LEFT_SWAP=%h, RIGHT_SWAP=%h",
                         LEFT_SWAP, RIGHT_SWAP);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LEFT_SWAP=%h, RIGHT_SWAP=%h",
                         expected_LEFT_SWAP, expected_RIGHT_SWAP);
                $display("  Got:      LEFT_SWAP=%h, RIGHT_SWAP=%h",
                         LEFT_SWAP, RIGHT_SWAP);
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
