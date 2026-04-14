`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] scancode;
    wire down;
    wire left;
    wire right;
    wire up;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .scancode(scancode),
        .down(down),
        .left(left),
        .right(right),
        .up(up)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Scancode Left (16'hE06B)", test_num);
            scancode = 16'hE06B;

            #1;


            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Scancode Down (16'hE072)", test_num);
            scancode = 16'hE072;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Scancode Right (16'hE074)", test_num);
            scancode = 16'hE074;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Scancode Up (16'hE075)", test_num);
            scancode = 16'hE075;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Invalid Scancode (16'h0000)", test_num);
            scancode = 16'h0000;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Random Scancode (16'hABCD)", test_num);
            scancode = 16'hABCD;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Partial Scancode Match (16'h006B)", test_num);
            scancode = 16'h006B;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Scancode All F (16'hFFFF)", test_num);
            scancode = 16'hFFFF;
            #1;

            check_outputs(0, 0, 0, 0);
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
        input expected_down;
        input expected_left;
        input expected_right;
        input expected_up;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_down === (expected_down ^ down ^ expected_down) &&
                expected_left === (expected_left ^ left ^ expected_left) &&
                expected_right === (expected_right ^ right ^ expected_right) &&
                expected_up === (expected_up ^ up ^ expected_up)) begin
                $display("PASS");
                $display("  Outputs: down=%b, left=%b, right=%b, up=%b",
                         down, left, right, up);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: down=%b, left=%b, right=%b, up=%b",
                         expected_down, expected_left, expected_right, expected_up);
                $display("  Got:      down=%b, left=%b, right=%b, up=%b",
                         down, left, right, up);
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
