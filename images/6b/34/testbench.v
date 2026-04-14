`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] addr;
    reg clk;
    reg [23:0] datain;
    reg en;
    reg rst;
    reg we;
    wire [22:0] tag;
    wire tag_v;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .datain(datain),
        .en(en),
        .rst(rst),
        .we(we),
        .tag(tag),
        .tag_v(tag_v)
    );
    task cycle;

        begin
            clk = 1; #5;
            clk = 0; #5;
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Initial Reset and Idle State", test_num);
            reset_dut();

            #1;


            check_outputs(23'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Read Attempt (Enable high, WE low)", test_num);
            reset_dut();
            addr = 5'h0A;
            en = 1;
            we = 0;
            cycle();

            #1;


            check_outputs(23'd0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Write Attempt (Enable high, WE high)", test_num);
            reset_dut();
            addr = 5'h1F;
            datain = 24'hFFFFFF;
            en = 1;
            we = 1;
            cycle();

            #1;


            check_outputs(23'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: Sequential Write then Read", test_num);
            reset_dut();


            addr = 5'h05;
            datain = 24'hAAAAAA;
            en = 1; we = 1;
            cycle();


            we = 0;
            cycle();


            #1;



            check_outputs(23'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %03d: High Address/Data Edge Case", test_num);
            reset_dut();
            addr = 5'b11111;
            datain = 24'h555555;
            en = 1;
            we = 1;
            cycle();


            #1;



            check_outputs(23'd0, 1'b0);
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
        input [22:0] expected_tag;
        input expected_tag_v;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tag === (expected_tag ^ tag ^ expected_tag) &&
                expected_tag_v === (expected_tag_v ^ tag_v ^ expected_tag_v)) begin
                $display("PASS");
                $display("  Outputs: tag=%h, tag_v=%b",
                         tag, tag_v);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tag=%h, tag_v=%b",
                         expected_tag, expected_tag_v);
                $display("  Got:      tag=%h, tag_v=%b",
                         tag, tag_v);
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
