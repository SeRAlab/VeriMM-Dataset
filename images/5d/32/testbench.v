`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] data_in;
    reg [1:0] shift_amount;
    wire [3:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .shift_amount(shift_amount),
        .data_out(data_out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: Positive value, shift_amount = 0 (No Shift)", test_num);
        data_in = 4'b0110;
        shift_amount = 2'b00;
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Positive value, shift_amount = 1", test_num);
        data_in = 4'b0110;
        shift_amount = 2'b01;
        #1;

        check_outputs(4'b0011);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Positive value, shift_amount = 2", test_num);
        data_in = 4'b0110;
        shift_amount = 2'b10;
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Positive value, shift_amount = 3", test_num);
        data_in = 4'b0110;
        shift_amount = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Negative value, shift_amount = 0 (No Shift)", test_num);
        data_in = 4'b1010;
        shift_amount = 2'b00;
        #1;

        check_outputs(4'b1010);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Negative value, shift_amount = 1", test_num);
        data_in = 4'b1010;
        shift_amount = 2'b01;
        #1;

        check_outputs(4'b1101);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Negative value, shift_amount = 2", test_num);
        data_in = 4'b1010;
        shift_amount = 2'b10;
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Negative value, shift_amount = 3", test_num);
        data_in = 4'b1010;
        shift_amount = 2'b11;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: Edge case, data_in = 1000, shift_amount = 1", test_num);
        data_in = 4'b1000;
        shift_amount = 2'b01;
        #1;

        check_outputs(4'b1100);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: All zeros, shift_amount = 3", test_num);
        data_in = 4'b0000;
        shift_amount = 2'b11;
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Test %0d: All ones, shift_amount = 3", test_num);
        data_in = 4'b1111;
        shift_amount = 2'b11;
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Test %0d: Max positive value (0111), shift_amount = 2", test_num);
        data_in = 4'b0111;
        shift_amount = 2'b10;
        #1;

        check_outputs(4'b0001);
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
