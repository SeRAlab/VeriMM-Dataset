`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg rst_n;
    wire [7:0] seg;
    wire [7:0] sel;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rst_n(rst_n),
        .seg(seg),
        .sel(sel)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Basic Reset check...", test_num);

        rst_n = 0;
        clk = 0;
        #20;
        rst_n = 1;
        #20;


        #1;



        check_outputs(8'h30, 8'h01);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Long-term stability check...", test_num);

        rst_n = 0;
        #10;
        rst_n = 1;


        repeat(20) @(posedge clk);

        #1;


        check_outputs(8'h30, 8'h01);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nRunning Testcase %0d: Secondary Reset check...", test_num);

        rst_n = 1;
        repeat(5) @(posedge clk);

        rst_n = 0;
        #20;
        rst_n = 1;
        #10;

        #1;


        check_outputs(8'h30, 8'h01);
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
        input [7:0] expected_seg;
        input [7:0] expected_sel;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg) &&
                expected_sel === (expected_sel ^ sel ^ expected_sel)) begin
                $display("PASS");
                $display("  Outputs: seg=%h, sel=%h",
                         seg, sel);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h, sel=%h",
                         expected_seg, expected_sel);
                $display("  Got:      seg=%h, sel=%h",
                         seg, sel);
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
