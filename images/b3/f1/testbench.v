`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] u;
    wire [8:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .u(u),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            u = 32'h00000000;
            $display("Test %0d: All Zeros", test_num);
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            u = 32'hFFFFFFFF;
            $display("Test %0d: All Ones", test_num);
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            u = 32'h00000200;
            $display("Test %0d: Minimum Range Bit (Bit 9)", test_num);
            #1;

            check_outputs(9'h001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            u = 32'h00020000;
            $display("Test %0d: Maximum Range Bit (Bit 17)", test_num);
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            u = 32'h0003FE00;
            $display("Test %0d: Full Range Set, Others Zero", test_num);
            #1;

            check_outputs(9'h1FF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            u = 32'hFFFC01FF;
            $display("Test %0d: Range Zeros, Others Set", test_num);
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            u = 32'h00015400;
            $display("Test %0d: Pattern 010101010", test_num);
            #1;

            check_outputs(9'h0AA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            u = 32'h0002AA00;
            $display("Test %0d: Pattern 101010101", test_num);
            #1;

            check_outputs(9'h155);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            u = 32'hDEADBEEF;
            $display("Test %0d: Hex DEADBEEF", test_num);
            #1;

            check_outputs(9'h0DF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            u = 32'h12345678;
            $display("Test %0d: Hex 12345678", test_num);
            #1;

            check_outputs(9'h02B);
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
        input [8:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
