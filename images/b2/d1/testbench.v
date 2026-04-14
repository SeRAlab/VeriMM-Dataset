`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] shift_amount;
    reg [1:0] shift_func;
    reg [31:0] value;
    wire [31:0] c_shift;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .shift_amount(shift_amount),
        .shift_func(shift_func),
        .value(value),
        .c_shift(c_shift)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift (unsigned) by 5 bits", test_num);
            shift_func = 2'b00;
            value = 32'h0000_0001;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h0000_0020);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift (signed) by 10 bits - Negative Value", test_num);
            shift_func = 2'b01;
            value = 32'h8000_0000;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hFFE0_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift (signed) by 10 bits - Positive Value", test_num);
            shift_func = 2'b01;
            value = 32'h7FC0_0000;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h001F_F000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift (unsigned) by 15 bits", test_num);
            shift_func = 2'b10;
            value = 32'h8000_0000;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h0001_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift (unsigned) by 20 bits", test_num);
            shift_func = 2'b11;
            value = 32'h0000_000F;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h00F0_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift 5 - All ones", test_num);
            shift_func = 2'b00;
            value = 32'hFFFF_FFFF;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hFFFF_FFE0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Right shift unsigned 15 - All ones", test_num);
            shift_func = 2'b10;
            value = 32'hFFFF_FFFF;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'h0001_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Left shift 20 - All ones", test_num);
            shift_func = 2'b11;
            value = 32'hFFFF_FFFF;
            shift_amount = 5'd0;
            #1;

            check_outputs(32'hFFF0_0000);
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
        input [31:0] expected_c_shift;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_c_shift === (expected_c_shift ^ c_shift ^ expected_c_shift)) begin
                $display("PASS");
                $display("  Outputs: c_shift=%h",
                         c_shift);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: c_shift=%h",
                         expected_c_shift);
                $display("  Got:      c_shift=%h",
                         c_shift);
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
