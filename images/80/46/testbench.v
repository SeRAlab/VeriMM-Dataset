`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg [31:0] pc_addr_i;
    reg [31:0] pc_instr_i;
    reg rst_n;
    wire [31:0] pc_addr_o;
    wire [31:0] pc_instr_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .pc_addr_i(pc_addr_i),
        .pc_instr_i(pc_instr_i),
        .rst_n(rst_n),
        .pc_addr_o(pc_addr_o),
        .pc_instr_o(pc_instr_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_n = 0;
            pc_addr_i = 32'h0;
            pc_instr_i = 32'h0;
            #15;
            rst_n = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Check");
            reset_dut();

            #1;


            check_outputs(32'h0000_0000, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Cycle Data Capture");
            reset_dut();
            @(posedge clk_i);
            pc_addr_i = 32'h0000_1000;
            pc_instr_i = 32'hA1B2C3D4;
            @(posedge clk_i);
            #2;
            #1;

            check_outputs(32'h0000_1000, 32'hA1B2C3D4);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Sequential Fetches");
            reset_dut();
            @(posedge clk_i);
            pc_addr_i = 32'h0000_1004; pc_instr_i = 32'h1111_1111;
            @(posedge clk_i);
            pc_addr_i = 32'h0000_1008; pc_instr_i = 32'h2222_2222;
            @(posedge clk_i);
            pc_addr_i = 32'h0000_100C; pc_instr_i = 32'h3333_3333;
            @(posedge clk_i);
            #2;

            #1;


            check_outputs(32'h0000_100C, 32'h3333_3333);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Asynchronous Reset Mid-Cycle");
            reset_dut();
            @(posedge clk_i);
            pc_addr_i = 32'hFFFF_FFFF;
            pc_instr_i = 32'hEEEE_EEEE;
            @(posedge clk_i);
            #2;

            rst_n = 0;
            #1;
            #1;

            check_outputs(32'h0000_0000, 32'h0000_0000);
            rst_n = 1;
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Data Holding Stability");
            reset_dut();
            @(posedge clk_i);
            pc_addr_i = 32'h1234_5678;
            pc_instr_i = 32'h8765_4321;
            @(posedge clk_i);
            #2;

            pc_addr_i = 32'h0;
            pc_instr_i = 32'h0;
            #3;

            #1;


            check_outputs(32'h1234_5678, 32'h8765_4321);
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
        input [31:0] expected_pc_addr_o;
        input [31:0] expected_pc_instr_o;
        begin
            if (expected_pc_addr_o === (expected_pc_addr_o ^ pc_addr_o ^ expected_pc_addr_o) &&
                expected_pc_instr_o === (expected_pc_instr_o ^ pc_instr_o ^ expected_pc_instr_o)) begin
                $display("PASS");
                $display("  Outputs: pc_addr_o=%h, pc_instr_o=%h",
                         pc_addr_o, pc_instr_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_addr_o=%h, pc_instr_o=%h",
                         expected_pc_addr_o, expected_pc_instr_o);
                $display("  Got:      pc_addr_o=%h, pc_instr_o=%h",
                         pc_addr_o, pc_instr_o);
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
        $dumpvars(0,clk_i, pc_addr_i, pc_instr_i, rst_n, pc_addr_o, pc_instr_o);
    end

endmodule
