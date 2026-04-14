`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] pc_in;
    wire [31:0] pc_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pc_in(pc_in),
        .pc_out(pc_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            pc_in = 32'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            pc_in = 32'h0000_0004;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0004);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            pc_in = 32'hABCD_1234;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCD_1234);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            pc_in = 32'hFFFF_FFFF;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;

            pc_in = 32'hFFFF_FFFF;
            @(posedge clk);

            pc_in = 32'h0000_0000;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            pc_in = 32'h5A5A_A5A5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5A5A_A5A5);
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
        $dumpvars(0,clk, pc_in, pc_out);
    end

endmodule
