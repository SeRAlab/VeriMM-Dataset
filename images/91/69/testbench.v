`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] br_addr;
    reg branch;
    reg busy;
    reg clk;
    reg [31:0] j_addr;
    reg jump;
    reg stall;
    wire [2:0] access_size;
    wire enable;
    wire [31:0] pc;
    wire rw;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .br_addr(br_addr),
        .branch(branch),
        .busy(busy),
        .clk(clk),
        .j_addr(j_addr),
        .jump(jump),
        .stall(stall),
        .access_size(access_size),
        .enable(enable),
        .pc(pc),
        .rw(rw)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            stall = 0;
            busy = 0;
            j_addr = 32'h0;
            jump = 1;
            br_addr = 32'h0;
            branch = 0;
            @(posedge clk);
            #1;
            jump = 0;
            $display("DUT Reset: PC set to 0");
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Increment (0 -> 4 -> 8)", test_num);
            reset_dut();

            repeat(2) @(posedge clk);
            #1;


            #1;



            check_outputs(3'd4, 1'b1, 32'd8, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump to Specific Address", test_num);
            reset_dut();
            #1;
            j_addr = 32'h0000_1000;
            jump = 1;
            @(posedge clk);
            #1;
            jump = 0;
            #1;

            check_outputs(3'd4, 1'b1, 32'h0000_1000, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Branch to Specific Address", test_num);
            reset_dut();
            #1;
            br_addr = 32'h0000_2000;
            branch = 1;
            @(posedge clk);
            #1;
            branch = 0;
            #1;

            check_outputs(3'd4, 1'b1, 32'h0000_2000, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stall Condition", test_num);
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            stall = 1;
            repeat(2) @(posedge clk);
            #1;

            #1;


            check_outputs(3'd4, 1'b0, 32'd8, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Busy Signal", test_num);
            reset_dut();
            #1;
            busy = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'd4, 1'b0, 32'd0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump while Stalled (Stall priority)", test_num);
            reset_dut();
            #1;
            stall = 1;
            j_addr = 32'hFFFF_0000;
            jump = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd4, 1'b0, 32'h0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Jump then Increment", test_num);
            reset_dut();
            #1;
            j_addr = 32'h0000_0500;
            jump = 1;
            @(posedge clk);
            #1;
            jump = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(3'd4, 1'b1, 32'h0000_0504, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complex Sequence (Jump -> Increment -> Branch)", test_num);
            reset_dut();
            #1;
            j_addr = 32'h100; jump = 1;
            @(posedge clk);
            #1;
            jump = 0;
            @(posedge clk);
            #1;
            br_addr = 32'h300; branch = 1;
            @(posedge clk);
            #1;
            branch = 0;
            #1;

            check_outputs(3'd4, 1'b1, 32'h300, 1'b0);
        end
        endtask

    task testcases1;

        begin
            testcase001();
            testcase002();
            testcase003();
            testcase004();
        end
        endtask

    task testcases2;

        begin
            testcase005();
            testcase006();
            testcase007();
            testcase008();
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
        testcases1();
        testcases2();
        
        
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
        input [2:0] expected_access_size;
        input expected_enable;
        input [31:0] expected_pc;
        input expected_rw;
        begin
            if (expected_access_size === (expected_access_size ^ access_size ^ expected_access_size) &&
                expected_enable === (expected_enable ^ enable ^ expected_enable) &&
                expected_pc === (expected_pc ^ pc ^ expected_pc) &&
                expected_rw === (expected_rw ^ rw ^ expected_rw)) begin
                $display("PASS");
                $display("  Outputs: access_size=%h, enable=%b, pc=%h, rw=%b",
                         access_size, enable, pc, rw);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: access_size=%h, enable=%b, pc=%h, rw=%b",
                         expected_access_size, expected_enable, expected_pc, expected_rw);
                $display("  Got:      access_size=%h, enable=%b, pc=%h, rw=%b",
                         access_size, enable, pc, rw);
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
        $dumpvars(0,br_addr, branch, busy, clk, j_addr, jump, stall, access_size, enable, pc, rw);
    end

endmodule
