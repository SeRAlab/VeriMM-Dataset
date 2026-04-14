`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire b_out;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .b_out(b_out),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple subtraction (10 - 5)", test_num);
            a = 8'd10;
            b = 8'd5;
            #1;

            check_outputs(1'b0, 8'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Subtraction with borrow (5 - 10)", test_num);
            a = 8'd5;
            b = 8'd10;

            #1;


            check_outputs(1'b1, 8'hFB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero result (255 - 255)", test_num);
            a = 8'd255;
            b = 8'd255;
            #1;

            check_outputs(1'b0, 8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum minus one (0 - 1)", test_num);
            a = 8'd0;
            b = 8'd1;
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Large values (200 - 150)", test_num);
            a = 8'd200;
            b = 8'd150;
            #1;

            check_outputs(1'b0, 8'd50);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max value (255 - 1)", test_num);
            a = 8'd255;
            b = 8'd1;
            #1;

            check_outputs(1'b0, 8'd254);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Borrow point (128 - 129)", test_num);
            a = 8'd128;
            b = 8'd129;
            #1;

            check_outputs(1'b1, 8'hFF);
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
        input expected_b_out;
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_b_out === (expected_b_out ^ b_out ^ expected_b_out) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: b_out=%b, y=%h",
                         b_out, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: b_out=%b, y=%h",
                         expected_b_out, expected_y);
                $display("  Got:      b_out=%b, y=%h",
                         b_out, y);
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
