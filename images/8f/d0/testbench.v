`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data;
    reg [1:0] shift_amount;
    wire [3:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .shift_amount(shift_amount),
        .result(result)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        data = 4'b1011;
        shift_amount = 2'b00;
        #5;
        $display("Test %0d: Data=%b, Shift=%d (No shift expected)", test_num, data, shift_amount);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        data = 4'b1011;
        shift_amount = 2'b01;
        #5;
        $display("Test %0d: Data=%b, Shift=%d (Left shift 1 expected)", test_num, data, shift_amount);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        data = 4'b1011;
        shift_amount = 2'b10;
        #5;
        $display("Test %0d: Data=%b, Shift=%d (Left shift 2 expected)", test_num, data, shift_amount);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        data = 4'b1011;
        shift_amount = 2'b11;
        #5;
        $display("Test %0d: Data=%b, Shift=%d (Zero output expected per spec)", test_num, data, shift_amount);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        data = 4'b1111;
        shift_amount = 2'b01;
        #5;
        $display("Test %0d: Data=%b, Shift=%d", test_num, data, shift_amount);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        data = 4'b1111;
        shift_amount = 2'b10;
        #5;
        $display("Test %0d: Data=%b, Shift=%d", test_num, data, shift_amount);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        data = 4'b1000;
        shift_amount = 2'b01;
        #5;
        $display("Test %0d: Data=%b, Shift=%d", test_num, data, shift_amount);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        data = 4'b0001;
        shift_amount = 2'b10;
        #5;
        $display("Test %0d: Data=%b, Shift=%d", test_num, data, shift_amount);
        #1;

        check_outputs(4'b0100);
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
        input [3:0] expected_result;
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
