`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg rst;
    wire [7:0] addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst(rst),
        .addr(addr)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Verifying Reset", test_num);
            clk = 0;
            rst = 1;
            #10 clk = 1; #10 clk = 0;
            rst = 0;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Verifying Single Increment (PC+1)", test_num);
            clk = 0;
            rst = 1;
            #10 clk = 1; #10 clk = 0;
            rst = 0;
            #10 clk = 1; #10 clk = 0;
            #10;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Verifying Multiple Increments (PC+15)", test_num);
            clk = 0;
            rst = 1;
            #10 clk = 1; #10 clk = 0;
            rst = 0;
            for (i = 0; i < 15; i = i + 1) begin
                #10 clk = 1; #10 clk = 0;
            end
            #10;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Verifying 8-bit Wrap-around", test_num);
            clk = 0;
            rst = 1;
            #10 clk = 1; #10 clk = 0;
            rst = 0;
            for (i = 0; i < 256; i = i + 1) begin
                #10 clk = 1; #10 clk = 0;
            end
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Verifying Reset Interruption", test_num);
            clk = 0;
            rst = 1;
            #10 clk = 1; #10 clk = 0;
            rst = 0;
            for (i = 0; i < 50; i = i + 1) begin
                #10 clk = 1; #10 clk = 0;
            end

            rst = 1;
            #10 clk = 1; #10 clk = 0;
            rst = 0;
            #10;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_addr;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_addr === (expected_addr ^ addr ^ expected_addr)) begin
                $display("PASS");
                $display("  Outputs: addr=%h",
                         addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: addr=%h",
                         expected_addr);
                $display("  Got:      addr=%h",
                         addr);
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
