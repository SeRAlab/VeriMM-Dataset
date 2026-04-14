`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg direction_left;
    reg [1:0] shift_amount;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .direction_left(direction_left),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'b00;
        direction_left = 1'b1;
        #10;
        $display("Test Case %0d: Shift Amount 00 (No shift)", test_num);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'b01;
        direction_left = 1'b1;
        #10;
        $display("Test Case %0d: Shift Amount 01 (Left shift 1)", test_num);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'b10;
        direction_left = 1'b1;
        #10;
        $display("Test Case %0d: Shift Amount 10 (Left shift 2)", test_num);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'b11;
        direction_left = 1'b1;
        #10;
        $display("Test Case %0d: Shift Amount 11, Direction Left (Left shift 2)", test_num);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        data_in = 4'b1011;
        shift_amount = 2'b11;
        direction_left = 1'b0;
        #10;
        $display("Test Case %0d: Shift Amount 11, Direction Right (Original input)", test_num);
        #1;

        check_outputs(4'b1011);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        data_in = 4'b1111;
        shift_amount = 2'b01;
        direction_left = 1'b1;
        #10;
        $display("Test Case %0d: Input 1111, Left shift 1", test_num);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        data_in = 4'b0001;
        shift_amount = 2'b10;
        direction_left = 1'b1;
        #10;
        $display("Test Case %0d: Input 0001, Left shift 2", test_num);
        #1;

        check_outputs(4'b0100);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        data_in = 4'b0101;
        shift_amount = 2'b11;
        direction_left = 1'b0;
        #10;
        $display("Test Case %0d: Input 0101, Shift Amount 11, Direction Right", test_num);
        #1;

        check_outputs(4'b0101);
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
        input [3:0] expected_data_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
