`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in0;
    reg [19:0] in1;
    reg [28:0] in2;
    wire [28:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in0(in0),
        .in1(in1),
        .in2(in2),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Zero", test_num);
            in0 = 8'd0;
            in1 = 20'd0;
            in2 = 29'd0;
            #1;

            check_outputs(29'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Positive Values", test_num);
            in0 = 8'd10;
            in1 = 20'd20;
            in2 = 29'd30;

            #1;


            check_outputs(29'd230);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum in0, zero others", test_num);
            in0 = 8'hFF;
            in1 = 20'd0;
            in2 = 29'd0;
            #1;

            check_outputs(29'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum in1, unit in0", test_num);
            in0 = 8'd1;
            in1 = 20'hFFFFF;
            in2 = 29'd0;
            #1;

            check_outputs(29'hFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum in2, zero others", test_num);
            in0 = 8'd0;
            in1 = 20'd0;
            in2 = 29'h1FFFFFFF;
            #1;

            check_outputs(29'h1FFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range multiplication and addition", test_num);
            in0 = 8'd50;
            in1 = 20'd2000;
            in2 = 29'd100000;

            #1;


            check_outputs(29'd200000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Multiplication Result (28 bits)", test_num);
            in0 = 8'hFF;
            in1 = 20'hFFFFF;
            in2 = 29'd0;

            #1;


            check_outputs(29'd267386625);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 check", test_num);
            in0 = 8'h80;
            in1 = 20'h80000;
            in2 = 29'h10000000;

            #1;


            check_outputs(29'h14000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: 29-bit Wrap-around Check", test_num);
            in0 = 8'hFF;
            in1 = 20'hFFFFF;
            in2 = 29'h1FFFFFFF;


            #1;



            check_outputs(29'd267386624);
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
        input [28:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
