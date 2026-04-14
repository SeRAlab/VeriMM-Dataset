`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pc_next;
    reg pc_we;
    wire [31:0] pc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pc_next(pc_next),
        .pc_we(pc_we),
        .pc(pc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pc_we <= 1;
            pc_next <= 32'h0;
            @(posedge clk);
            #1;
            pc_we <= 0;
            pc_next <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Load...");
            reset_dut();
            pc_we <= 1;
            pc_next <= 32'h12345678;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Write Disable...");
            reset_dut();

            pc_we <= 1;
            pc_next <= 32'hAAAA_BBBB;
            @(posedge clk);
            #1;

            pc_we <= 0;
            pc_next <= 32'hCCCC_DDDD;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA_BBBB);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential Updates...");
            reset_dut();
            pc_we <= 1;
            pc_next <= 32'h0000_0004;
            @(posedge clk);
            #1;
            pc_next <= 32'h0000_0008;
            @(posedge clk);
            #1;
            pc_next <= 32'h0000_000C;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_000C);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Toggling Write Enable...");
            reset_dut();

            pc_we <= 1;
            pc_next <= 32'h1111_1111;
            @(posedge clk);
            #1;

            pc_we <= 0;
            pc_next <= 32'h2222_2222;
            @(posedge clk);
            #1;

            pc_we <= 1;
            pc_next <= 32'h3333_3333;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h3333_3333);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Boundary Values...");
            reset_dut();
            pc_we <= 1;
            pc_next <= 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Data stability mid-cycle...");
            reset_dut();
            pc_we <= 1;
            pc_next <= 32'h5555_AAAA;
            @(posedge clk);
            #1;

            pc_next <= 32'hEEEE_FFFF;
            #2;
            #1;

            check_outputs(32'h5555_AAAA);
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
        input [31:0] expected_pc;
        begin
            if (expected_pc === (expected_pc ^ pc ^ expected_pc)) begin
                $display("PASS");
                $display("  Outputs: pc=%h",
                         pc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc=%h",
                         expected_pc);
                $display("  Got:      pc=%h",
                         pc);
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
        $dumpvars(0,clk, pc_next, pc_we, pc);
    end

endmodule
