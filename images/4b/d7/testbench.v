`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] wi;
    reg [31:0] xi;
    wire [1:0] cout;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .wi(wi),
        .xi(xi),
        .cout(cout),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            wi = 32'h0000_0000;
            xi = 32'h0000_0000;
            #1;

            check_outputs(2'd0, 8'd16);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            wi = 32'h0000_0000;
            xi = 32'h0000_FFFF;
            #1;

            check_outputs(2'd0, 8'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            wi = 32'h0000_00FF;
            xi = 32'h0000_0000;
            #1;

            check_outputs(2'd0, 8'd8);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            wi = 32'hFFFF_FFFF;
            xi = 32'hFFFF_FFFF;
            #1;

            check_outputs(2'd0, 8'd16);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            wi = 32'h0000_5555;
            xi = 32'h0000_AAAA;
            #1;

            check_outputs(2'd0, 8'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            wi = 32'h0000_0001;
            xi = 32'h0000_0000;
            #1;

            check_outputs(2'd0, 8'd15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            wi = 32'h0000_1234;
            xi = 32'h0000_4321;
            #1;

            check_outputs(2'd0, 8'd10);
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
        input [1:0] expected_cout;
        input [7:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%h, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%h, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%h, sum=%h",
                         cout, sum);
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
