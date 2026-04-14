`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [7:0] in1;
    wire [7:0] out0;
    wire [7:0] out1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .out0(out0),
        .out1(out1)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in0 < in1", test_num);
        in0 = 8'd10;
        in1 = 8'd20;
        #1;

        check_outputs(8'd10, 8'd20);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in0 > in1", test_num);
        in0 = 8'd100;
        in1 = 8'd50;
        #1;

        check_outputs(8'd50, 8'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: in0 == in1", test_num);
        in0 = 8'hAA;
        in1 = 8'hAA;
        #1;

        check_outputs(8'hAA, 8'hAA);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Minimum values (0)", test_num);
        in0 = 8'd0;
        in1 = 8'd0;
        #1;

        check_outputs(8'd0, 8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values (255)", test_num);
        in0 = 8'd255;
        in1 = 8'd255;
        #1;

        check_outputs(8'd255, 8'd255);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary values 0 and 255", test_num);
        in0 = 8'd255;
        in1 = 8'd0;
        #1;

        check_outputs(8'd0, 8'd255);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Neighboring values", test_num);
        in0 = 8'd127;
        in1 = 8'd128;
        #1;

        check_outputs(8'd127, 8'd128);
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
        input [7:0] expected_out0;
        input [7:0] expected_out1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out0 === (expected_out0 ^ out0 ^ expected_out0) &&
                expected_out1 === (expected_out1 ^ out1 ^ expected_out1)) begin
                $display("PASS");
                $display("  Outputs: out0=%h, out1=%h",
                         out0, out1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out0=%h, out1=%h",
                         expected_out0, expected_out1);
                $display("  Got:      out0=%h, out1=%h",
                         out0, out1);
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
