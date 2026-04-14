`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] x;
    reg [15:0] y;
    wire borrow_out;
    wire [15:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .borrow_out(borrow_out),
        .diff(diff)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x = 16'd500;
            y = 16'd200;
            $display("Test Case %0d: Basic Subtraction (500 - 200)", test_num);
            #1;

            check_outputs(1'b0, 16'd300);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 16'd200;
            y = 16'd500;
            $display("Test Case %0d: Borrow Case (200 - 500)", test_num);

            #1;


            check_outputs(1'b1, 16'hFE6C);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 16'hFFFF;
            y = 16'hFFFF;
            $display("Test Case %0d: Zero Result (Max Values)", test_num);
            #1;

            check_outputs(1'b0, 16'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 16'hA5A5;
            y = 16'd0;
            $display("Test Case %0d: Subtracting Zero", test_num);
            #1;

            check_outputs(1'b0, 16'hA5A5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 16'd0;
            y = 16'd1;
            $display("Test Case %0d: Zero minus One", test_num);
            #1;

            check_outputs(1'b1, 16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 16'h8000;
            y = 16'h7FFF;
            $display("Test Case %0d: MSB Boundary (0x8000 - 0x7FFF)", test_num);
            #1;

            check_outputs(1'b0, 16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 16'h0000;
            y = 16'hFFFF;
            $display("Test Case %0d: Max Borrow (0 - 0xFFFF)", test_num);
            #1;

            check_outputs(1'b1, 16'h0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x = 16'hF000;
            y = 16'h1000;
            $display("Test Case %0d: Large values (0xF000 - 0x1000)", test_num);
            #1;

            check_outputs(1'b0, 16'hE000);
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
        input expected_borrow_out;
        input [15:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, diff=%h",
                         borrow_out, diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, diff=%h",
                         expected_borrow_out, expected_diff);
                $display("  Got:      borrow_out=%b, diff=%h",
                         borrow_out, diff);
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
