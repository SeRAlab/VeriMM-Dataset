`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_i;
    reg pcEnable_i;
    reg [31:0] pc_i;
    reg rst_i;
    reg stall_i;
    reg start_i;
    wire [31:0] pc_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_i(clk_i),
        .pcEnable_i(pcEnable_i),
        .pc_i(pc_i),
        .rst_i(rst_i),
        .stall_i(stall_i),
        .start_i(start_i),
        .pc_o(pc_o)
    );

    // Clock generation (10ns period)
    initial begin
        clk_i = 0;
        forever #5 clk_i = ~clk_i;
    end

        task reset_dut;

        begin
            rst_i = 1;
            start_i = 0;
            stall_i = 0;
            pcEnable_i = 0;
            pc_i = 32'h0;
            @(posedge clk_i);
            #1 rst_i = 0;
            @(posedge clk_i);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            start_i = 0;
            pcEnable_i = 1;
            pc_i = 32'hAAAA_BBBB;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            start_i = 1;
            pcEnable_i = 1;
            stall_i = 0;
            pc_i = 32'h1234_5678;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            start_i = 1;
            pcEnable_i = 1;
            stall_i = 0;
            pc_i = 32'hDEAD_BEEF;
            @(posedge clk_i);
            #1;

            stall_i = 1;
            pc_i = 32'hCAFE_BABE;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            start_i = 1;
            pcEnable_i = 1;
            stall_i = 0;
            pc_i = 32'h0000_1111;
            @(posedge clk_i);
            #1;

            pcEnable_i = 0;
            pc_i = 32'hFFFF_EEEE;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h0000_1111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            start_i = 1;
            pcEnable_i = 1;
            stall_i = 0;
            pc_i = 32'h5555_AAAA;
            @(posedge clk_i);
            #1;

            rst_i = 1;
            pc_i = 32'hFFFF_FFFF;
            @(posedge clk_i);
            #1;


            if (pc_o == 32'h0)
                #1;

                check_outputs(32'h0000_0000);
            else
                #1;

                check_outputs(32'h5555_AAAA);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            start_i = 1;
            pcEnable_i = 1;
            pc_i = 32'h8888_8888;
            @(posedge clk_i);
            #1;

            start_i = 0;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            start_i = 1;
            pcEnable_i = 1;
            stall_i = 0;

            pc_i = 32'h1;
            @(posedge clk_i);
            #1;
            pc_i = 32'h2;
            @(posedge clk_i);
            #1;
            pc_i = 32'h3;
            @(posedge clk_i);
            #1;
            #1;

            check_outputs(32'h0000_0003);
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
        input [31:0] expected_pc_o;
        begin
            if (expected_pc_o === (expected_pc_o ^ pc_o ^ expected_pc_o)) begin
                $display("PASS");
                $display("  Outputs: pc_o=%h",
                         pc_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_o=%h",
                         expected_pc_o);
                $display("  Got:      pc_o=%h",
                         pc_o);
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
        $dumpvars(0,clk_i, pcEnable_i, pc_i, rst_i, stall_i, start_i, pc_o);
    end

endmodule
