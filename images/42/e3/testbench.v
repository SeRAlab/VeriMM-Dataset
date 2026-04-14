`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg config_in;
    reg config_rst;
    reg [1:0] in;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .config_in(config_in),
        .config_rst(config_rst),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b00;
        config_in = 1'b0;
        $display("Test Case 001: Select in[0] (config_in=0), Data in=2'b00");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b01;
        config_in = 1'b0;
        $display("Test Case 002: Select in[0] (config_in=0), Data in=2'b01");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b10;
        config_in = 1'b0;
        $display("Test Case 003: Select in[0] (config_in=0), Data in=2'b10");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b11;
        config_in = 1'b0;
        $display("Test Case 004: Select in[0] (config_in=0), Data in=2'b11");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b00;
        config_in = 1'b1;
        $display("Test Case 005: Select in[1] (config_in=1), Data in=2'b00");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b01;
        config_in = 1'b1;
        $display("Test Case 006: Select in[1] (config_in=1), Data in=2'b01");
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b10;
        config_in = 1'b1;
        $display("Test Case 007: Select in[1] (config_in=1), Data in=2'b10");
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        config_rst = 1;
        #10;
        config_rst = 0;
        in = 2'b11;
        config_in = 1'b1;
        $display("Test Case 008: Select in[1] (config_in=1), Data in=2'b11");
        #1;

        check_outputs(1'b1);
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
