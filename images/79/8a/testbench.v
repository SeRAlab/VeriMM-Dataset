`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg dir;
    reg [3:0] in;
    reg [1:0] shift_amt;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dir(dir),
        .in(in),
        .shift_amt(shift_amt),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Left Shift, Amount 0", test_num);
            in = 4'b1011;
            shift_amt = 2'b00;
            dir = 1'b0;
            #1;

            check_outputs(4'b1011);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Left Shift, Amount 1", test_num);
            in = 4'b1011;
            shift_amt = 2'b01;
            dir = 1'b0;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Left Shift, Amount 2", test_num);
            in = 4'b1011;
            shift_amt = 2'b10;
            dir = 1'b0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Left Shift, Amount 3", test_num);
            in = 4'b1011;
            shift_amt = 2'b11;
            dir = 1'b0;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Right Shift, Amount 0", test_num);
            in = 4'b1101;
            shift_amt = 2'b00;
            dir = 1'b1;
            #1;

            check_outputs(4'b1101);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Right Shift, Amount 1", test_num);
            in = 4'b1101;
            shift_amt = 2'b01;
            dir = 1'b1;
            #1;

            check_outputs(4'b0110);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Right Shift, Amount 2", test_num);
            in = 4'b1101;
            shift_amt = 2'b10;
            dir = 1'b1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Right Shift, Amount 3", test_num);
            in = 4'b1101;
            shift_amt = 2'b11;
            dir = 1'b1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: All 1s, Left Shift 2", test_num);
            in = 4'b1111;
            shift_amt = 2'b10;
            dir = 1'b0;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: All 1s, Right Shift 2", test_num);
            in = 4'b1111;
            shift_amt = 2'b10;
            dir = 1'b1;
            #1;

            check_outputs(4'b0011);
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
        input [3:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
