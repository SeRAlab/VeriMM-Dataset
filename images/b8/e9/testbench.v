`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pc_in;
    reg rst_n;
    wire [31:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pc_in(pc_in),
        .rst_n(rst_n),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst_n = 0;
            pc_in = 32'h0;
            @(posedge clk);
            #1;
            rst_n = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Verifying Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading simple address (0x4)", test_num);
            reset_dut();
            pc_in = 32'h0000_0004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Loading large address (0xDEADBEEF)", test_num);
            reset_dut();
            pc_in = 32'hDEAD_BEEF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEAD_BEEF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Sequential updates", test_num);
            reset_dut();
            pc_in = 32'h100;
            @(posedge clk);
            #1;
            pc_in = 32'h104;
            @(posedge clk);
            #1;
            pc_in = 32'h108;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h108);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary value (0xFFFFFFFF)", test_num);
            reset_dut();
            pc_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset priority test", test_num);
            reset_dut();
            pc_in = 32'h1234_5678;
            rst_n = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
            rst_n = 1;
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
        input [31:0] expected_pc_out;
        begin
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h",
                         pc_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h",
                         expected_pc_out);
                $display("  Got:      pc_out=%h",
                         pc_out);
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
        $dumpvars(0,clk, pc_in, rst_n, pc_out);
    end

endmodule
