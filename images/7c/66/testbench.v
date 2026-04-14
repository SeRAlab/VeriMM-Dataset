`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [23:0] x;
    reg [23:0] y;
    wire [5:0] cout;
    wire s0;
    wire s1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .y(y),
        .cout(cout),
        .s0(s0),
        .s1(s1)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            x = 24'hAAAAAA;
            y = 24'h555555;
            #1;

            check_outputs(6'b000000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            x = 24'hABCDEF;
            y = 24'hABCDEF;
            #1;

            check_outputs(6'b111111, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            x = 24'h000000;
            y = 24'hFFEFE;
            #1;

            check_outputs(6'b000000, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            x = 24'h000000;
            y = 24'hFFCFCC;
            #1;

            check_outputs(6'b000001, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            x = 24'h000000;
            y = 24'h7FF7FF;
            #1;

            check_outputs(6'h20, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            x = 24'h000000;
            y = 24'hAA5555;
            #1;

            check_outputs(6'b000000, 1'b1, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            x = 24'h000000;
            y = 24'hBA9DDC;
            #1;

            check_outputs(6'b000001, 1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            x = 24'h000000;
            y = 24'hFFF800;

            y = 24'hFFE800;
            #1;

            check_outputs(6'h1F, 1'b0, 1'b0);
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
        input [5:0] expected_cout;
        input expected_s0;
        input expected_s1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_s0 === (expected_s0 ^ s0 ^ expected_s0) &&
                expected_s1 === (expected_s1 ^ s1 ^ expected_s1)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, s0=%b, s1=%b",
                         cout, s0, s1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, s0=%b, s1=%b",
                         expected_cout, expected_s0, expected_s1);
                $display("  Got:      cout=%h, s0=%b, s1=%b",
                         cout, s0, s1);
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
