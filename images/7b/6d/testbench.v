`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg SEL;
    wire [7:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SEL(SEL),
        .C(C)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Addition (SEL=0, 10 + 20)", test_num);
        SEL = 0; A = 8'd10; B = 8'd20;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with Saturation (SEL=0, 200 + 100)", test_num);
        SEL = 0; A = 8'd200; B = 8'd100;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition exact boundary (SEL=0, 200 + 55)", test_num);
        SEL = 0; A = 8'd200; B = 8'd55;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Addition with zeros (SEL=0, 0 + 0)", test_num);
        SEL = 0; A = 8'd0; B = 8'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Subtraction (SEL=1, 50 - 20)", test_num);
        SEL = 1; A = 8'd50; B = 8'd20;
        #1;

        check_outputs(8'd30);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction result zero (SEL=1, 45 - 45)", test_num);
        SEL = 1; A = 8'd45; B = 8'd45;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction underflow (SEL=1, 10 - 50)", test_num);
        SEL = 1; A = 8'd10; B = 8'd50;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtraction from max (SEL=1, 255 - 1)", test_num);
        SEL = 1; A = 8'd255; B = 8'd1;
        #1;

        check_outputs(8'd254);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Extreme addition (SEL=0, 255 + 255)", test_num);
        SEL = 0; A = 8'd255; B = 8'd255;
        #1;

        check_outputs(8'd255);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Extreme subtraction (SEL=1, 0 - 255)", test_num);
        SEL = 1; A = 8'd0; B = 8'd255;
        #1;

        check_outputs(8'd0);
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
        input [7:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
