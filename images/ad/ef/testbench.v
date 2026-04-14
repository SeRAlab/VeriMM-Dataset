`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] control;
    reg [7:0] num;
    reg [3:0] shift_amount;
    wire [7:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .num(num),
        .shift_amount(shift_amount),
        .result(result)
    );
    task testcase001;

    begin
        test_num = 1;
        num = 8'hA5;
        shift_amount = 4'd0;
        control = 2'b00;
        #1;

        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        num = 8'hA5;
        shift_amount = 4'd1;
        control = 2'b00;
        #1;

        check_outputs(8'h4A);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        num = 8'h0F;
        shift_amount = 4'd4;
        control = 2'b00;
        #1;

        check_outputs(8'hF0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        num = 8'hFF;
        shift_amount = 4'd8;
        control = 2'b00;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        num = 8'hFF;
        shift_amount = 4'd0;
        control = 2'b01;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        num = 8'h80;
        shift_amount = 4'd1;
        control = 2'b01;
        #1;

        check_outputs(8'h40);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        num = 8'hF0;
        shift_amount = 4'd4;
        control = 2'b01;
        #1;

        check_outputs(8'h0F);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        num = 8'h70;
        shift_amount = 4'd1;
        control = 2'b10;
        #1;

        check_outputs(8'h38);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        num = 8'h80;
        shift_amount = 4'd1;
        control = 2'b10;
        #1;

        check_outputs(8'hC0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        num = 8'h80;
        shift_amount = 4'd7;
        control = 2'b10;
        #1;

        check_outputs(8'hFF);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        num = 8'hFF;
        shift_amount = 4'd2;
        control = 2'b11;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        num = 8'hA5;
        shift_amount = 4'd15;
        control = 2'b01;
        #1;

        check_outputs(8'h00);
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
