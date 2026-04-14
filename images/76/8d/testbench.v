`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg address0;
    reg address1;
    reg enable;
    wire out0;
    wire out1;
    wire out2;
    wire out3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address0(address0),
        .address1(address1),
        .enable(enable),
        .out0(out0),
        .out1(out1),
        .out2(out2),
        .out3(out3)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Enable=0, Address=00 (Disabled State)", test_num);
            enable = 0;
            address1 = 0;
            address0 = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Enable=0, Address=11 (Disabled State)", test_num);
            enable = 0;
            address1 = 1;
            address0 = 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Enable=1, Address=00 (Select Out0)", test_num);
            enable = 1;
            address1 = 0;
            address0 = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Enable=1, Address=01 (Select Out1)", test_num);
            enable = 1;
            address1 = 0;
            address0 = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Enable=1, Address=10 (Select Out2)", test_num);
            enable = 1;
            address1 = 1;
            address0 = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Enable=1, Address=11 (Select Out3)", test_num);
            enable = 1;
            address1 = 1;
            address0 = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Switching Enable from 1 to 0 with Address=10", test_num);

            enable = 1; address1 = 1; address0 = 0;
            #5;

            enable = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Enable=1, Address=01 (Verify bit order)", test_num);
            enable = 1;
            address1 = 0;
            address0 = 1;
            #1;

            check_outputs(0, 1, 0, 0);
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
        input expected_out0;
        input expected_out1;
        input expected_out2;
        input expected_out3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1) &&
                expected_out2 === (expected_out2 ^ out2 ^ expected_out2) &&
                expected_out3 === (expected_out3 ^ out3 ^ expected_out3)) begin
                $display("PASS");
                $display("  Outputs: out0=%b, out1=%b, out2=%b, out3=%b",
                         out0, out1, out2, out3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%b, out1=%b, out2=%b, out3=%b",
                         expected_out0, expected_out1, expected_out2, expected_out3);
                $display("  Got:      out0=%b, out1=%b, out2=%b, out3=%b",
                         out0, out1, out2, out3);
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
