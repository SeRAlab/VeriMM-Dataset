`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg branch_flag_i;
    reg [31:0] branch_target_address_i;
    reg clk;
    reg flush;
    reg [31:0] new_pc;
    reg rst;
    reg [5:0] stall;
    wire ce;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .branch_flag_i(branch_flag_i),
        .branch_target_address_i(branch_target_address_i),
        .clk(clk),
        .flush(flush),
        .new_pc(new_pc),
        .rst(rst),
        .stall(stall),
        .ce(ce),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            stall = 6'b0;
            flush = 0;
            new_pc = 32'h0;
            branch_flag_i = 0;
            branch_target_address_i = 32'h0;
            @(posedge clk);
            #2;
            rst = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset State", test_num);
            rst = 1;
            stall = 6'b0;
            flush = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Normal Increment", test_num);
            reset_dut();

            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Stall PC Update", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            stall = 6'b000001;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h0000_0004);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Branch Redirect", test_num);
            reset_dut();
            branch_flag_i = 1;
            branch_target_address_i = 32'h0000_1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h0000_1000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Flush Operation", test_num);
            reset_dut();
            flush = 1;
            new_pc = 32'h0000_2000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h0000_2000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Flush Priority Over Branch", test_num);
            reset_dut();
            flush = 1;
            new_pc = 32'h0000_AAAA;
            branch_flag_i = 1;
            branch_target_address_i = 32'h0000_BBBB;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h0000_AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Stall Priority Over Branch", test_num);
            reset_dut();

            @(posedge clk);
            #1;
            stall = 6'b000001;
            branch_flag_i = 1;
            branch_target_address_i = 32'h0000_5555;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1'b1, 32'h0000_0004);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Complex Sequence (Jump then Increment)", test_num);
            reset_dut();

            branch_flag_i = 1;
            branch_target_address_i = 32'h0000_F000;
            @(posedge clk);
            #1;

            branch_flag_i = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 32'h0000_F004);
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
        input expected_ce;
        input [31:0] expected_pc;
        begin
            if (expected_ce === (expected_ce ^ ce ^ expected_ce) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: ce=%b, pc=%h",
                         ce, pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ce=%b, pc=%h",
                         expected_ce, expected_pc);
                $display("  Got:      ce=%b, pc=%h",
                         ce, pc);
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
        $dumpvars(0,branch_flag_i, branch_target_address_i, clk, flush, new_pc, rst, stall, ce, pc);
    end

endmodule
