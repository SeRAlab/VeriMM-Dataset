`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] binary_number;
    wire [3:0] decimal_number;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_number(binary_number),
        .decimal_number(decimal_number)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 0000 (Decimal 0)", test_num);
        binary_number = 4'b0000;
        #1;

        check_outputs(4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 0011 (Decimal 3)", test_num);
        binary_number = 4'b0011;
        #1;

        check_outputs(4'd3);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 0111 (Decimal 7)", test_num);
        binary_number = 4'b0111;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 1111 (Decimal -1 -> Abs 1)", test_num);
        binary_number = 4'b1111;
        #1;

        check_outputs(4'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 1100 (Decimal -4 -> Abs 4)", test_num);
        binary_number = 4'b1100;
        #1;

        check_outputs(4'd4);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 1001 (Decimal -7 -> Abs 7)", test_num);
        binary_number = 4'b1001;
        #1;

        check_outputs(4'd7);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Input 1000 (Decimal -8 -> Abs 8)", test_num);
        binary_number = 4'b1000;
        #1;

        check_outputs(4'd8);
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
        input [3:0] expected_decimal_number;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_decimal_number === (expected_decimal_number ^ decimal_number ^ expected_decimal_number)) begin
                $display("PASS");
                $display("  Outputs: decimal_number=%h",
                         decimal_number);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: decimal_number=%h",
                         expected_decimal_number);
                $display("  Got:      decimal_number=%h",
                         decimal_number);
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
