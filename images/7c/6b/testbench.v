`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] i_data0;
    wire [31:0] o_data0;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .i_data0(i_data0),
        .o_data0(o_data0)
    );
    task testcase001;

        begin
            $display("Test Case 001: Zero Input");
            test_num = test_num + 1;
            i_data0 = 32'd0;
            #1;

            check_outputs(32'd0 * 32'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Unit Input");
            test_num = test_num + 1;
            i_data0 = 32'd1;
            #1;

            check_outputs(32'd1 * 32'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Small Integer");
            test_num = test_num + 1;
            i_data0 = 32'd5;
            #1;

            check_outputs(32'd5 * 32'd5);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Square of 10");
            test_num = test_num + 1;
            i_data0 = 32'd10;
            #1;

            check_outputs(32'd10 * 32'd10);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Maximum 8-bit value");
            test_num = test_num + 1;
            i_data0 = 32'hFF;
            #1;

            check_outputs(32'hFF * 32'hFF);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Maximum 16-bit value (Result fits in 32-bit)");
            test_num = test_num + 1;
            i_data0 = 32'hFFFF;
            #1;

            check_outputs(32'hFFFF * 32'hFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: 17-bit value (Result will overflow 32-bit)");
            test_num = test_num + 1;
            i_data0 = 32'h10000;

            #1;


            check_outputs(32'h10000 * 32'h10000);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: Bit Pattern 0101...");
            test_num = test_num + 1;
            i_data0 = 32'h5555_5555;
            #1;

            check_outputs(32'h5555_5555 * 32'h5555_5555);
        end
        endtask

    task testcase009;

        begin
            $display("Test Case 009: Bit Pattern 1010...");
            test_num = test_num + 1;
            i_data0 = 32'hAAAA_AAAA;
            #1;

            check_outputs(32'hAAAA_AAAA * 32'hAAAA_AAAA);
        end
        endtask

    task testcase010;

        begin
            $display("Test Case 010: Arbitrary Large Value");
            test_num = test_num + 1;
            i_data0 = 32'h1234_5678;
            #1;

            check_outputs(32'h1234_5678 * 32'h1234_5678);
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
        input [31:0] expected_o_data0;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o_data0 === (expected_o_data0 ^ o_data0 ^ expected_o_data0)) begin
                $display("PASS");
                $display("  Outputs: o_data0=%h",
                         o_data0);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o_data0=%h",
                         expected_o_data0);
                $display("  Got:      o_data0=%h",
                         o_data0);
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
