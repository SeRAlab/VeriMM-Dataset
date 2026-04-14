`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] binary_in;
    reg clk;
    reg reset;
    wire [9:0] bcd_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .binary_in(binary_in),
        .clk(clk),
        .reset(reset),
        .bcd_out(bcd_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 0", test_num);
        reset = 1;
        binary_in = 8'd0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 7", test_num);
        reset = 1;
        binary_in = 8'd7;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h007);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 10", test_num);
        reset = 1;
        binary_in = 8'd10;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h010);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 42", test_num);
        reset = 1;
        binary_in = 8'd42;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h042);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 99", test_num);
        reset = 1;
        binary_in = 8'd99;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h099);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 100", test_num);
        reset = 1;
        binary_in = 8'd100;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h100);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 158", test_num);
        reset = 1;
        binary_in = 8'd158;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h158);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Binary Input = 255", test_num);
        reset = 1;
        binary_in = 8'd255;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;

        check_outputs(10'h255);
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
        input [9:0] expected_bcd_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bcd_out === (expected_bcd_out ^ bcd_out ^ expected_bcd_out)) begin
                $display("PASS");
                $display("  Outputs: bcd_out=%h",
                         bcd_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bcd_out=%h",
                         expected_bcd_out);
                $display("  Got:      bcd_out=%h",
                         bcd_out);
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
