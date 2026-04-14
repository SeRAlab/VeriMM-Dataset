`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [29:0] branch_pc_i;
    reg clk_i;
    reg [31:0] rmemdata_i;
    reg rst_i;
    reg stall_i;
    reg take_branch_i;
    wire [31:0] ir_o;
    wire [29:0] nextpc_o;
    wire re_o;
    wire [29:0] rmemaddr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_pc_i(branch_pc_i),
        .clk_i(clk_i),
        .rmemdata_i(rmemdata_i),
        .rst_i(rst_i),
        .stall_i(stall_i),
        .take_branch_i(take_branch_i),
        .ir_o(ir_o),
        .nextpc_o(nextpc_o),
        .re_o(re_o),
        .rmemaddr_o(rmemaddr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            stall_i = 0;
            take_branch_i = 0;
            branch_pc_i = 30'h0;
            rmemdata_i = 32'h0;
            @(posedge clk_i);
            #2;
            rst_i = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Post-Reset Initial State", test_num);
            reset_dut();




            #1;





            check_outputs(32'h00000000, 30'h00000000, 1'b1, 30'h3FFFFFFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal PC Increment (3FFFFFFF -> 0)", test_num);
            reset_dut();
            @(posedge clk_i);
            #1;



            #1;




            check_outputs(32'h00000000, 30'h00000001, 1'b1, 30'h00000000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Consecutive Increments", test_num);
            reset_dut();
            repeat(2) @(posedge clk_i);
            #1;



            #1;




            check_outputs(32'h00000000, 30'h00000002, 1'b1, 30'h00000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Branch Target Combinational Check", test_num);
            reset_dut();
            take_branch_i = 1;
            branch_pc_i = 30'h12345678;
            #1;

            #1;


            check_outputs(32'h00000000, 30'h12345678, 1'b1, 30'h3FFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Branch Execution PC Update", test_num);
            reset_dut();
            take_branch_i = 1;
            branch_pc_i = 30'h00ABCDEF;
            @(posedge clk_i);
            #1;


            take_branch_i = 0;
            #1;
            #1;

            check_outputs(32'h00000000, 30'h00ABCDF0, 1'b1, 30'h00ABCDEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Stall Condition - PC Hold", test_num);
            reset_dut();
            stall_i = 1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h00000000, 30'h00000000, 1'b0, 30'h3FFFFFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Stall Condition - Read Enable", test_num);
            reset_dut();
            stall_i = 1;
            #1;

            #1;


            check_outputs(32'h00000000, 30'h00000000, 1'b0, 30'h3FFFFFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Instruction Data Feed-through", test_num);
            reset_dut();
            rmemdata_i = 32'hA5A5B6B6;
            #1;

            #1;


            check_outputs(32'hA5A5B6B6, 30'h00000000, 1'b1, 30'h3FFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %03d: Stall and Branch Interaction", test_num);
            reset_dut();
            take_branch_i = 1;
            branch_pc_i = 30'h100;
            stall_i = 1;
            @(posedge clk_i);
            #1;

            #1;


            check_outputs(32'h00000000, 30'h00000100, 1'b0, 30'h3FFFFFFF);
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
        input [31:0] expected_ir_o;
        input [29:0] expected_nextpc_o;
        input expected_re_o;
        input [29:0] expected_rmemaddr_o;
        begin
            if (expected_ir_o === (expected_ir_o ^ ir_o ^ expected_ir_o) &&
                expected_nextpc_o === (expected_nextpc_o ^ nextpc_o ^ expected_nextpc_o) &&
                expected_re_o === (expected_re_o ^ re_o ^ expected_re_o) &&
                expected_rmemaddr_o === (expected_rmemaddr_o ^ rmemaddr_o ^ expected_rmemaddr_o)) begin
                $display("PASS");
                $display("  Outputs: ir_o=%h, nextpc_o=%h, re_o=%b, rmemaddr_o=%h",
                         ir_o, nextpc_o, re_o, rmemaddr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ir_o=%h, nextpc_o=%h, re_o=%b, rmemaddr_o=%h",
                         expected_ir_o, expected_nextpc_o, expected_re_o, expected_rmemaddr_o);
                $display("  Got:      ir_o=%h, nextpc_o=%h, re_o=%b, rmemaddr_o=%h",
                         ir_o, nextpc_o, re_o, rmemaddr_o);
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
        $dumpvars(0,branch_pc_i, clk_i, rmemdata_i, rst_i, stall_i, take_branch_i, ir_o, nextpc_o, re_o, rmemaddr_o);
    end

endmodule
