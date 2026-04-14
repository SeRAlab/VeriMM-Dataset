`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data_in;
    reg [4:0] shift_amount;
    wire [31:0] data_out;
    wire zero_flag;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out),
        .zero_flag(zero_flag)
    );
    task testcase001;

    begin
        test_num = 1;
        data_in = 32'hA5A5A5A5;
        shift_amount = 5'd0;
        #1;

        check_outputs(32'hA5A5A5A5, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        data_in = 32'h00000001;
        shift_amount = 5'd1;
        #1;

        check_outputs(32'h00000002, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        data_in = 32'h12345678;
        shift_amount = 5'd4;
        #1;

        check_outputs(32'h23456780, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        data_in = 32'h0000FFFF;
        shift_amount = 5'd16;
        #1;

        check_outputs(32'hFFFF0000, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        data_in = 32'h00000001;
        shift_amount = 5'd31;
        #1;

        check_outputs(32'h80000000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        data_in = 32'h80000000;
        shift_amount = 5'd1;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        data_in = 32'h00000000;
        shift_amount = 5'd15;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        data_in = 32'hF0F0F0F0;
        shift_amount = 5'd4;
        #1;

        check_outputs(32'h0F0F0F00, 1'b0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        data_in = 32'hF0000000;
        shift_amount = 5'd4;
        #1;

        check_outputs(32'h00000000, 1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        data_in = 32'h55555555;
        shift_amount = 5'd1;
        #1;

        check_outputs(32'hAAAAAAAA, 1'b0);
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
        input [31:0] expected_data_out;
        input expected_zero_flag;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_zero_flag === (expected_zero_flag ^ zero_flag ^ expected_zero_flag)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, zero_flag=%b",
                         data_out, zero_flag);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, zero_flag=%b",
                         expected_data_out, expected_zero_flag);
                $display("  Got:      data_out=%h, zero_flag=%b",
                         data_out, zero_flag);
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
