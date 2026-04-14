`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] current_test;
    wire [22:0] data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .current_test(current_test),
        .data(data)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: Testing input with LSB 2'b00", test_num);
        current_test = 5'b00000;
        #1;

        check_outputs(23'h7ABCDE);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: Testing input with LSB 2'b01", test_num);
        current_test = 5'b00001;
        #1;

        check_outputs(23'h712345);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Testing input with LSB 2'b10", test_num);
        current_test = 5'b00010;
        #1;

        check_outputs(23'h767890);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Testing input with LSB 2'b11", test_num);
        current_test = 5'b00011;
        #1;

        check_outputs(23'h7BBCCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Testing input with non-zero upper bits and LSB 2'b00", test_num);
        current_test = 5'b11100;
        #1;

        check_outputs(23'h7ABCDE);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Testing input with non-zero upper bits and LSB 2'b01", test_num);
        current_test = 5'b10101;
        #1;

        check_outputs(23'h712345);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Testing input with non-zero upper bits and LSB 2'b10", test_num);
        current_test = 5'b01010;
        #1;

        check_outputs(23'h767890);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Testing input with non-zero upper bits and LSB 2'b11", test_num);
        current_test = 5'b11111;
        #1;

        check_outputs(23'h7BBCCD);
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
        input [22:0] expected_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_data === (expected_data ^ data ^ expected_data)) begin
                $display("PASS");
                $display("  Outputs: data=%h",
                         data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data=%h",
                         expected_data);
                $display("  Got:      data=%h",
                         data);
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
