`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] input1;
    reg [15:0] input2;
    wire [30:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .input1(input1),
        .input2(input2),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero inputs", test_num);
        input1 = 16'd0; input2 = 16'd0;
        #1;

        check_outputs(31'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero input 1", test_num);
        input1 = 16'd0; input2 = 16'd500;
        #1;

        check_outputs(31'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero input 2", test_num);
        input1 = 16'd-100; input2 = 16'd0;
        #1;

        check_outputs(31'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Positive", test_num);
        input1 = 16'd12; input2 = 16'd12;
        #1;

        check_outputs(31'd144);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Positive", test_num);
        input1 = -16'd10; input2 = 16'd5;

        #1;


        check_outputs(31'h7FFFFFCE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Positive * Negative", test_num);
        input1 = 16'd8; input2 = -16'd4;

        #1;


        check_outputs(31'h7FFFFFE0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Negative * Negative", test_num);
        input1 = -16'd15; input2 = -16'd3;
        #1;

        check_outputs(31'd45);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive * 2", test_num);
        input1 = 16'h7FFF; input2 = 16'd2;
        #1;

        check_outputs(31'd65534);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * 1", test_num);
        input1 = 16'h8000; input2 = 16'd1;
        #1;

        check_outputs(31'h7FFF8000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: -1 * -1", test_num);
        input1 = -16'd1; input2 = -16'd1;
        #1;

        check_outputs(31'd1);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Positive * Max Positive", test_num);
        input1 = 16'h7FFF; input2 = 16'h7FFF;
        #1;

        check_outputs(31'h3FFF0001);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Min Negative * Max Positive", test_num);
        input1 = 16'h8000; input2 = 16'h7FFF;
        #1;

        check_outputs(31'h40008000);
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
        input [30:0] expected_out;
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
