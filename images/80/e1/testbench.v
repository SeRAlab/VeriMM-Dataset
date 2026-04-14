`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg ctrl;
    wire [7:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .ctrl(ctrl),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'd15;
            b = 8'd10;
            ctrl = 1'b0;
            $display("Test %0d: Addition (15 + 10)", test_num);
            #1;

            check_outputs(8'd25);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'hFF;
            b = 8'h01;
            ctrl = 1'b0;
            $display("Test %0d: Addition Overflow (255 + 1)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'hAA;
            b = 8'h55;
            ctrl = 1'b0;
            $display("Test %0d: Addition Bit Pattern (0xAA + 0x55)", test_num);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'd50;
            b = 8'd20;
            ctrl = 1'b1;
            $display("Test %0d: Subtraction (50 - 20)", test_num);
            #1;

            check_outputs(8'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'd10;
            b = 8'd20;
            ctrl = 1'b1;
            $display("Test %0d: Subtraction Underflow (10 - 20)", test_num);
            #1;

            check_outputs(8'd246);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h00;
            b = 8'h01;
            ctrl = 1'b1;
            $display("Test %0d: Subtraction Underflow (0 - 1)", test_num);
            #1;

            check_outputs(8'hFF);
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
        input [7:0] expected_out;
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
