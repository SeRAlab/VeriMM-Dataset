`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] div;
    wire [15:0] mul;
    wire [8:0] shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .div(div),
        .mul(mul),
        .shift(shift)
    );
    task testcase001;

    begin
        test_num = 1;
        div = 8'd1;
        #10;

        #1;


        check_outputs(16'h0001, 9'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        div = 8'd2;
        #10;

        #1;


        check_outputs(16'h8000, 9'd16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        div = 8'd3;
        #10;

        #1;


        check_outputs(16'h5555, 9'd16);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        div = 8'd4;
        #10;
        #1;

        check_outputs(16'h4000, 9'd16);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        div = 8'd10;
        #10;

        #1;


        check_outputs(16'h199A, 9'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        div = 8'd64;
        #10;
        #1;

        check_outputs(16'h0400, 9'd16);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        div = 8'd255;
        #10;

        #1;


        check_outputs(16'h0101, 9'd16);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        div = 8'd7;
        #10;

        #1;


        check_outputs(16'h2492, 9'd16);
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
        input [15:0] expected_mul;
        input [8:0] expected_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_mul === (expected_mul ^ mul ^ expected_mul) &&
                expected_shift === (expected_shift ^ shift ^ expected_shift)) begin
                $display("PASS");
                $display("  Outputs: mul=%h, shift=%h",
                         mul, shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mul=%h, shift=%h",
                         expected_mul, expected_shift);
                $display("  Got:      mul=%h, shift=%h",
                         mul, shift);
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
