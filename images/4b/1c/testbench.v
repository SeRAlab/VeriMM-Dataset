`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire borrow_out;
    wire [3:0] difference;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .difference(difference)
    );
    task testcase001;

        begin
            a = 4'd10; b = 4'd5;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            a = 4'd5; b = 4'd10;
            #1;

            check_outputs(1'b1, 4'd11);
        end
        endtask

    task testcase003;

        begin
            a = 4'd0; b = 4'd0;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase004;

        begin
            a = 4'd15; b = 4'd15;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        begin
            a = 4'd15; b = 4'd0;
            #1;

            check_outputs(1'b0, 4'd15);
        end
        endtask

    task testcase006;

        begin
            a = 4'd0; b = 4'd1;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase007;

        begin
            a = 4'd8; b = 4'd7;
            #1;

            check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase008;

        begin
            a = 4'd7; b = 4'd8;
            #1;

            check_outputs(1'b1, 4'd15);
        end
        endtask

    task testcase009;

        begin
            a = 4'd0; b = 4'd15;
            #1;

            check_outputs(1'b1, 4'd1);
        end
        endtask

    task testcase010;

        begin
            a = 4'b1010; b = 4'b1010;
            #1;

            check_outputs(1'b0, 4'b0000);
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
        input expected_borrow_out;
        input [3:0] expected_difference;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_difference === (expected_difference ^ difference ^ expected_difference)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, difference=%h",
                         borrow_out, difference);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, difference=%h",
                         expected_borrow_out, expected_difference);
                $display("  Got:      borrow_out=%b, difference=%h",
                         borrow_out, difference);
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
