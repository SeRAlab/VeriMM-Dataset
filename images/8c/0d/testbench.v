`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg control;
    reg [11:0] in1;
    reg [11:0] in2;
    wire [11:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .control(control),
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in1 (Control = 0)", test_num);
        in1 = 12'hA5A;
        in2 = 12'h5A5;
        control = 0;
        #1;

        check_outputs(12'hA5A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Select in2 (Control = 1)", test_num);
        in1 = 12'hA5A;
        in2 = 12'h5A5;
        control = 1;
        #1;

        check_outputs(12'h5A5);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Zeros Test (Control = 0)", test_num);
        in1 = 12'h000;
        in2 = 12'hFFF;
        control = 0;
        #1;

        check_outputs(12'h000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: All Ones Test (Control = 1)", test_num);
        in1 = 12'h000;
        in2 = 12'hFFF;
        control = 1;
        #1;

        check_outputs(12'hFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking Bits in1 (Control = 0)", test_num);
        in1 = 12'b101010101010;
        in2 = 12'b010101010101;
        control = 0;
        #1;

        check_outputs(12'b101010101010);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Walking Bits in2 (Control = 1)", test_num);
        in1 = 12'b101010101010;
        in2 = 12'b010101010101;
        control = 1;
        #1;

        check_outputs(12'b010101010101);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Values (Control = 0)", test_num);
        in1 = 12'hC39;
        in2 = 12'h2B4;
        control = 0;
        #1;

        check_outputs(12'hC39);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random Values (Control = 1)", test_num);
        in1 = 12'hC39;
        in2 = 12'h2B4;
        control = 1;
        #1;

        check_outputs(12'h2B4);
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
        input [11:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
