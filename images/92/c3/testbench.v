`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [1:0] shift_amount;
    reg shift_dir;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .shift_amount(shift_amount),
        .shift_dir(shift_dir),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = 1;
            A = 4'b1011;
            shift_amount = 2'd0;
            shift_dir = 1'b0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            A = 4'b1011;
            shift_amount = 2'd1;
            shift_dir = 1'b0;
            #1;

            check_outputs(4'b0101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            A = 4'b1011;
            shift_amount = 2'd2;
            shift_dir = 1'b0;
            #1;

            check_outputs(4'b0010);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            A = 4'b1011;
            shift_amount = 2'd3;
            shift_dir = 1'b0;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            A = 4'b0111;
            shift_amount = 2'd0;
            shift_dir = 1'b1;
            #1;

            check_outputs(4'b0111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            A = 4'b0111;
            shift_amount = 2'd1;
            shift_dir = 1'b1;
            #1;

            check_outputs(4'b1110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            A = 4'b0111;
            shift_amount = 2'd2;
            shift_dir = 1'b1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            A = 4'b0111;
            shift_amount = 2'd3;
            shift_dir = 1'b1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            A = 4'b0000;
            shift_amount = 2'd2;
            shift_dir = 1'b1;
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            A = 4'b1111;
            shift_amount = 2'd2;
            shift_dir = 1'b1;
            #1;

            check_outputs(4'b1100);
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
