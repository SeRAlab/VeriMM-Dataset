`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg equ;
    reg [15:0] pr2_IR;
    reg [15:0] pr3_IR;
    reg [15:0] pr4_IR;
    reg [15:0] pr5_IR;
    wire [2:0] pc_mux_select;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .equ(equ),
        .pr2_IR(pr2_IR),
        .pr3_IR(pr3_IR),
        .pr4_IR(pr4_IR),
        .pr5_IR(pr5_IR),
        .pc_mux_select(pc_mux_select)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            equ = 0;
            pr2_IR = OP_NOP;
            pr3_IR = OP_NOP;
            pr4_IR = OP_NOP;
            pr5_IR = OP_NOP;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase %03d: Default (All NOPs)", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            pr3_IR = OP_BEQ;
            equ = 1;
            @(posedge clk);
            #1;
            $display("Testcase %03d: BEQ Taken in stage 3", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            pr3_IR = OP_BEQ;
            equ = 0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: BEQ Not Taken in stage 3", test_num);
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            pr3_IR = OP_BNE;
            equ = 0;
            @(posedge clk);
            #1;
            $display("Testcase %03d: BNE Taken in stage 3", test_num);
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            pr2_IR = OP_JMP;
            @(posedge clk);
            #1;
            $display("Testcase %03d: JMP detected in stage 2", test_num);
            #1;

            check_outputs(3'b010);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            pr2_IR = OP_JR;
            @(posedge clk);
            #1;
            $display("Testcase %03d: JR detected in stage 2", test_num);
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clk);
            pr2_IR = OP_RET;
            @(posedge clk);
            #1;
            $display("Testcase %03d: RET detected in stage 2", test_num);
            #1;

            check_outputs(3'b100);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(negedge clk);
            pr3_IR = OP_BEQ;
            equ = 1;
            pr2_IR = OP_JMP;
            @(posedge clk);
            #1;
            $display("Testcase %03d: Priority - Resolved Branch vs Jump", test_num);
            #1;

            check_outputs(3'b001);
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
        input [2:0] expected_pc_mux_select;
        begin
            if (expected_pc_mux_select === (expected_pc_mux_select ^ pc_mux_select ^ expected_pc_mux_select)) begin
                $display("PASS");
                $display("  Outputs: pc_mux_select=%h",
                         pc_mux_select);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_mux_select=%h",
                         expected_pc_mux_select);
                $display("  Got:      pc_mux_select=%h",
                         pc_mux_select);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk, equ, pr2_IR, pr3_IR, pr4_IR, pr5_IR, pc_mux_select);
    end

endmodule
