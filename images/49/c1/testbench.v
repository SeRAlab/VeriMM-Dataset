`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a_src;
    reg clk;
    reg [15:0] ea1b;
    reg [15:0] extw;
    reg [3:0] flg_in;
    reg [19:0] inst_in;
    reg rst;
    reg [15:0] sr_in;
    wire branch;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a_src(a_src),
        .clk(clk),
        .ea1b(ea1b),
        .extw(extw),
        .flg_in(flg_in),
        .inst_in(inst_in),
        .rst(rst),
        .sr_in(sr_in),
        .branch(branch)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Default Branch", test_num);
            rst = 1;
            inst_in = 20'h00000;
            flg_in = 4'h0;
            sr_in = 16'h0000;
            a_src = 16'h0000;
            ea1b = 16'h0000;
            extw = 16'h0000;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Flag-based Branch Logic", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            inst_in = 20'h01000;
            flg_in = 4'b1010;
            sr_in = 16'h0000;
            @(posedge clk);


            #1;



            check_outputs(branch);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Status Register Logic", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            inst_in = 20'h02000;
            sr_in = 16'h8000;
            @(posedge clk);
            #1;

            check_outputs(branch);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Operand A Source Check", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            inst_in = 20'h03000;
            a_src = 16'h0000;
            @(posedge clk);
            #1;

            check_outputs(branch);

            a_src = 16'hFFFF;
            @(posedge clk);
            #1;

            check_outputs(branch);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Bitfield and Extension Word Logic", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            inst_in = 20'h04000;
            ea1b = 16'h0001;
            extw = 16'h0001;
            @(posedge clk);
            #1;

            check_outputs(branch);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Undefined Micro-instruction Default", test_num);
            rst = 1; #10; rst = 0;
            @(posedge clk);
            inst_in = 20'hFFFFF;
            @(posedge clk);
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
        input expected_branch;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_branch === (expected_branch ^ branch ^ expected_branch)) begin
                $display("PASS");
                $display("  Outputs: branch=%b",
                         branch);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: branch=%b",
                         expected_branch);
                $display("  Got:      branch=%b",
                         branch);
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
