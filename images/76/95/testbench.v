`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [9:0] sign;
    wire [31:0] _sign;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sign(sign),
        ._sign(_sign)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Positive Zero", test_num);
            sign = 10'h000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum Positive Value (511)", test_num);
            sign = 10'h1FF;
            #1;

            check_outputs(32'h000001FF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Minimum Negative Value (-512)", test_num);
            sign = 10'h200;
            #1;

            check_outputs(32'hFFFFFE00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Negative One (-1)", test_num);
            sign = 10'h3FF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary Positive Value", test_num);
            sign = 10'h0A5;
            #1;

            check_outputs(32'h000000A5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Arbitrary Negative Value", test_num);
            sign = 10'h35A;
            #1;

            check_outputs(32'hFFFFF35A);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Positive (Sign bit 0, next bit 1)", test_num);
            sign = 10'h100;
            #1;

            check_outputs(32'h00000100);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary Negative (Sign bit 1, next bit 0)", test_num);
            sign = 10'h2FF;
            #1;

            check_outputs(32'hFFFFF2FF);
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
        input [31:0] expected__sign;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected__sign === (expected__sign ^ _sign ^ expected__sign)) begin
                $display("PASS");
                $display("  Outputs: _sign=%h",
                         _sign);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: _sign=%h",
                         expected__sign);
                $display("  Got:      _sign=%h",
                         _sign);
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
