`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] commandIn;
    wire [15:0] addressOut;
    wire [7:0] operationOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .commandIn(commandIn),
        .addressOut(addressOut),
        .operationOut(operationOut)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            commandIn = 24'h000000;
            #1;

            check_outputs(16'h0000, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            commandIn = 24'hFFFFFF;
            #1;

            check_outputs(16'hFFFF, 8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits A5", test_num);
            commandIn = 24'hA5A5A5;
            #1;

            check_outputs(16'hA5A5, 8'hA5);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 123456", test_num);
            commandIn = 24'h123456;
            #1;

            check_outputs(16'h1234, 8'h56);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Operation bits high, address low", test_num);
            commandIn = 24'h0000FF;
            #1;

            check_outputs(16'h0000, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Address bits high, operation low", test_num);
            commandIn = 24'hFFFF00;
            #1;

            check_outputs(16'hFFFF, 8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern ABCD12", test_num);
            commandIn = 24'hABCD12;
            #1;

            check_outputs(16'hABCD, 8'h12);
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
        input [15:0] expected_addressOut;
        input [7:0] expected_operationOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addressOut === (expected_addressOut ^ addressOut ^ expected_addressOut) &&
                expected_operationOut === (expected_operationOut ^ operationOut ^ expected_operationOut)) begin
                $display("PASS");
                $display("  Outputs: addressOut=%h, operationOut=%h",
                         addressOut, operationOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addressOut=%h, operationOut=%h",
                         expected_addressOut, expected_operationOut);
                $display("  Got:      addressOut=%h, operationOut=%h",
                         addressOut, operationOut);
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
