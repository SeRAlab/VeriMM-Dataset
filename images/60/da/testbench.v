`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [7:0] max;
    wire [7:0] min;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .max(max),
        .min(min)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Basic initialization", test_num);
        rst = 1; in = 8'd0; @(posedge clk);
        rst = 0; in = 8'd42; @(posedge clk);

        #1;


        check_outputs(8'd42, 8'd42);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Finding a new maximum", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'd50;  @(posedge clk);
        in = 8'd100; @(posedge clk);
        #1;

        check_outputs(8'd100, 8'd50);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Finding a new minimum", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'd50;  @(posedge clk);
        in = 8'd20;  @(posedge clk);
        #1;

        check_outputs(8'd50, 8'd20);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Value between current min and max", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'd100; @(posedge clk);
        in = 8'd50;  @(posedge clk);
        in = 8'd75;  @(posedge clk);
        #1;

        check_outputs(8'd100, 8'd50);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Boundary values (0 and 255)", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'd128; @(posedge clk);
        in = 8'd255; @(posedge clk);
        in = 8'd0;   @(posedge clk);
        #1;

        check_outputs(8'd255, 8'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Stream of increasing values", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'd10; @(posedge clk);
        in = 8'd20; @(posedge clk);
        in = 8'd30; @(posedge clk);
        in = 8'd40; @(posedge clk);
        #1;

        check_outputs(8'd40, 8'd10);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Stream of decreasing values", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'd100; @(posedge clk);
        in = 8'd80;  @(posedge clk);
        in = 8'd60;  @(posedge clk);
        in = 8'd40;  @(posedge clk);
        #1;

        check_outputs(8'd100, 8'd40);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: All identical values", test_num);
        rst = 1; @(posedge clk);
        rst = 0;
        in = 8'hAA; @(posedge clk);
        in = 8'hAA; @(posedge clk);
        in = 8'hAA; @(posedge clk);
        #1;

        check_outputs(8'hAA, 8'hAA);
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
        input [7:0] expected_max;
        input [7:0] expected_min;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_max === (expected_max ^ max ^ expected_max) &&
                expected_min === (expected_min ^ min ^ expected_min)) begin
                $display("PASS");
                $display("  Outputs: max=%h, min=%h",
                         max, min);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: max=%h, min=%h",
                         expected_max, expected_min);
                $display("  Got:      max=%h, min=%h",
                         max, min);
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
