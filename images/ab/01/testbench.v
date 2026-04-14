`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    reg [3:0] shift_amount;
    wire carry_out;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .carry_out(carry_out),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        data_in = 16'hABCD;
        shift_amount = 4'd0;
        #1;

        check_outputs(1'b0, 16'hABCD);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        data_in = 16'h8001;
        shift_amount = 4'd1;
        #1;

        check_outputs(1'b1, 16'h0002);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        data_in = 16'h7FFF;
        shift_amount = 4'd1;
        #1;

        check_outputs(1'b0, 16'hFFFE);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        data_in = 16'hFF00;
        shift_amount = 4'd8;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        data_in = 16'h1234;
        shift_amount = 4'd4;
        #1;

        check_outputs(1'b1, 16'h2340);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        data_in = 16'h0002;
        shift_amount = 4'd15;
        #1;

        check_outputs(1'b1, 16'h0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        data_in = 16'h0003;
        shift_amount = 4'd15;
        #1;

        check_outputs(1'b1, 16'h8000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        data_in = 16'h4000;
        shift_amount = 4'd2;
        #1;

        check_outputs(1'b1, 16'h0000);
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
        input expected_carry_out;
        input [15:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, data_out=%h",
                         carry_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, data_out=%h",
                         expected_carry_out, expected_data_out);
                $display("  Got:      carry_out=%b, data_out=%h",
                         carry_out, data_out);
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
