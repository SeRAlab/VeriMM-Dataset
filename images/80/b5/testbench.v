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
        a_src = 0; ea1b = 0; extw = 0; flg_in = 0; inst_in = 0; sr_in = 0;
        reset_dut();

        #1;


        check_outputs(1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        inst_in = 20'hF0000;
        flg_in  = 4'b0000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        inst_in = 20'h10000;
        flg_in  = 4'b1000;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        inst_in = 20'h10000;
        flg_in  = 4'b0111;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        inst_in = 20'h20000;
        a_src   = 16'hAAAA;
        ea1b    = 16'hAAAA;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        inst_in = 20'h20000;
        a_src   = 16'hAAAA;
        ea1b    = 16'h5555;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        inst_in = 20'h30000;
        sr_in   = 16'h0001;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();
        inst_in = 20'h40000;
        extw    = 16'hFFFF;

        #1;


        check_outputs(1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        reset_dut();
        inst_in = 20'h50000;
        flg_in  = 4'b0010;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        reset_dut();
        inst_in = 20'h00000;
        flg_in  = 4'b1111;
        #1;

        check_outputs(1'b0);
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
