`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] inst;
    reg reset;
    reg stall;
    wire [31:0] cpi;
    wire [31:0] ipc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .inst(inst),
        .reset(reset),
        .stall(stall),
        .cpi(cpi),
        .ipc(ipc)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            inst = 0;
            stall = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1:1 Instruction to Cycle ratio (Ideal)", test_num);
            reset_dut();
            repeat(10) begin
                inst = 1;
                stall = 0;
                @(posedge clk);
                #1;
            end

            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd1, 32'd1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stalled cycles (50%% efficiency)", test_num);
            reset_dut();

            repeat(10) begin
                inst = 1;
                stall = 0;
                @(posedge clk);
                #1;
            end

            repeat(10) begin
                inst = 1;
                stall = 1;
                @(posedge clk);
                #1;
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd2, 32'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Superscalar (4 instructions per cycle)", test_num);
            reset_dut();
            repeat(10) begin
                inst = 4;
                stall = 0;
                @(posedge clk);
                #1;
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd0, 32'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Idle CPU (All cycles stalled)", test_num);
            reset_dut();
            repeat(10) begin
                inst = 1;
                stall = 1;
                @(posedge clk);
                #1;
            end
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'd0, 32'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed throughput and stalls", test_num);
            reset_dut();

            repeat(5) begin
                inst = 4; stall = 0;
                @(posedge clk); #1;
            end

            repeat(10) begin
                inst = 1; stall = 1;
                @(posedge clk); #1;
            end
            @(posedge clk);
            #1;


            #1;



            check_outputs(32'd0, 32'd1);
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
        input [31:0] expected_cpi;
        input [31:0] expected_ipc;
        begin
            if (expected_cpi === (expected_cpi ^ cpi ^ expected_cpi) &&
                expected_ipc === (expected_ipc ^ ipc ^ expected_ipc)) begin
                $display("PASS");
                $display("  Outputs: cpi=%h, ipc=%h",
                         cpi, ipc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cpi=%h, ipc=%h",
                         expected_cpi, expected_ipc);
                $display("  Got:      cpi=%h, ipc=%h",
                         cpi, ipc);
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
        $dumpvars(0,clk, inst, reset, stall, cpi, ipc);
    end

endmodule
