`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data_in;
    wire [7:0] lower_byte;
    wire [7:0] upper_byte;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data_in(data_in),
        .lower_byte(lower_byte),
        .upper_byte(upper_byte)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTestcase %0d: All Zeros", test_num);
        data_in = 16'h0000;
        #1;

        check_outputs(8'h00, 8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTestcase %0d: All Ones", test_num);
        data_in = 16'hFFFF;
        #1;

        check_outputs(8'hFF, 8'hFF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTestcase %0d: Standard Hex Pattern 1234", test_num);
        data_in = 16'h1234;
        #1;

        check_outputs(8'h34, 8'h12);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTestcase %0d: Standard Hex Pattern ABCD", test_num);
        data_in = 16'hABCD;
        #1;

        check_outputs(8'hCD, 8'hAB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTestcase %0d: Only Lower Byte Set", test_num);
        data_in = 16'h00FF;
        #1;

        check_outputs(8'hFF, 8'h00);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTestcase %0d: Only Upper Byte Set", test_num);
        data_in = 16'hFF00;
        #1;

        check_outputs(8'h00, 8'hFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTestcase %0d: Alternating Bit Pattern", test_num);
        data_in = 16'hA55A;
        #1;

        check_outputs(8'h5A, 8'hA5);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTestcase %0d: Boundary Bit Check", test_num);
        data_in = 16'h8001;
        #1;

        check_outputs(8'h01, 8'h80);
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
        input [7:0] expected_lower_byte;
        input [7:0] expected_upper_byte;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_lower_byte === (expected_lower_byte ^ lower_byte ^ expected_lower_byte) &&
                expected_upper_byte === (expected_upper_byte ^ upper_byte ^ expected_upper_byte)) begin
                $display("PASS");
                $display("  Outputs: lower_byte=%h, upper_byte=%h",
                         lower_byte, upper_byte);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: lower_byte=%h, upper_byte=%h",
                         expected_lower_byte, expected_upper_byte);
                $display("  Got:      lower_byte=%h, upper_byte=%h",
                         lower_byte, upper_byte);
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
