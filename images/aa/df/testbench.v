`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg clk;
    reg fetch;
    wire exception;
    wire [31:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .fetch(fetch),
        .exception(exception),
        .res(res)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 10 / 2", test_num);
        A = 32'd10;
        B = 32'd2;
        fetch = 0;
        @(posedge clk);
        fetch = 1;
        @(posedge clk);
        fetch = 0;

        repeat(40) @(posedge clk);
        #1;

        check_outputs(1'b0, 32'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 5 / 10", test_num);
        A = 32'd5;
        B = 32'd10;
        fetch = 0;
        @(posedge clk);
        fetch = 1;
        @(posedge clk);
        fetch = 0;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(1'b0, 32'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 100 / 100", test_num);
        A = 32'd100;
        B = 32'd100;
        fetch = 0;
        @(posedge clk);
        fetch = 1;
        @(posedge clk);
        fetch = 0;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(1'b0, 32'd1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 0 / 50", test_num);
        A = 32'd0;
        B = 32'd50;
        fetch = 0;
        @(posedge clk);
        fetch = 1;
        @(posedge clk);
        fetch = 0;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(1'b0, 32'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Max / 1", test_num);
        A = 32'hFFFFFFFF;
        B = 32'd1;
        fetch = 0;
        @(posedge clk);
        fetch = 1;
        @(posedge clk);
        fetch = 0;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(1'b0, 32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 10 / 3 (Integer Truncation)", test_num);
        A = 32'd10;
        B = 32'd3;
        fetch = 0;
        @(posedge clk);
        fetch = 1;
        @(posedge clk);
        fetch = 0;
        repeat(40) @(posedge clk);
        #1;

        check_outputs(1'b0, 32'd3);
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
        input expected_exception;
        input [31:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_exception === (expected_exception ^ exception ^ expected_exception) &&
                expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: exception=%b, res=%h",
                         exception, res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: exception=%b, res=%h",
                         expected_exception, expected_res);
                $display("  Got:      exception=%b, res=%h",
                         exception, res);
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
