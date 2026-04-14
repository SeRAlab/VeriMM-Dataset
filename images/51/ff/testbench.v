`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in1;
    reg [7:0] in2;
    wire out_eq;
    wire out_gt;
    wire out_lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in1(in1),
        .in2(in2),
        .out_eq(out_eq),
        .out_gt(out_gt),
        .out_lt(out_lt)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=0, in2=0 (Equality)", test_num);
        in1 = 8'd0;
        in2 = 8'd0;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=255, in2=255 (Equality)", test_num);
        in1 = 8'd255;
        in2 = 8'd255;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=1, in2=0 (Greater Than)", test_num);
        in1 = 8'd1;
        in2 = 8'd0;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=0, in2=1 (Less Than)", test_num);
        in1 = 8'd0;
        in2 = 8'd1;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=200, in2=50 (Greater Than)", test_num);
        in1 = 8'd200;
        in2 = 8'd50;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=50, in2=200 (Less Than)", test_num);
        in1 = 8'd50;
        in2 = 8'd200;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=128, in2=127 (Greater Than - MSB toggle)", test_num);
        in1 = 8'b10000000;
        in2 = 8'b01111111;
        #1;

        check_outputs(0, 1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=127, in2=128 (Less Than - MSB toggle)", test_num);
        in1 = 8'b01111111;
        in2 = 8'b10000000;
        #1;

        check_outputs(0, 0, 1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=170, in2=170 (Equality)", test_num);
        in1 = 8'd170;
        in2 = 8'd170;
        #1;

        check_outputs(1, 0, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: in1=255, in2=254 (Greater Than)", test_num);
        in1 = 8'd255;
        in2 = 8'd254;
        #1;

        check_outputs(0, 1, 0);
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
        input expected_out_eq;
        input expected_out_gt;
        input expected_out_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_eq === (expected_out_eq ^ out_eq ^ expected_out_eq) &&
                expected_out_gt === (expected_out_gt ^ out_gt ^ expected_out_gt) &&
                expected_out_lt === (expected_out_lt ^ out_lt ^ expected_out_lt)) begin
                $display("PASS");
                $display("  Outputs: out_eq=%b, out_gt=%b, out_lt=%b",
                         out_eq, out_gt, out_lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_eq=%b, out_gt=%b, out_lt=%b",
                         expected_out_eq, expected_out_gt, expected_out_lt);
                $display("  Got:      out_eq=%b, out_gt=%b, out_lt=%b",
                         out_eq, out_gt, out_lt);
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
