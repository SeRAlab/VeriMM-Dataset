`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [12:0] ir_addr;
    reg load;
    reg rst;
    wire [12:0] pc_addr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .ir_addr(ir_addr),
        .load(load),
        .rst(rst),
        .pc_addr(pc_addr)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            ir_addr = 0;
            @(posedge clock);
            #1;
            rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Reset", test_num);
            reset_dut();
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Load address", test_num);
            reset_dut();
            ir_addr = 13'h0ABC;
            load = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(13'h0ABC);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sequential Increment (3 cycles)", test_num);
            reset_dut();
            load = 0;
            @(posedge clock);
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(13'h0003);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Load then Increment", test_num);
            reset_dut();
            ir_addr = 13'h1F00;
            load = 1;
            @(posedge clock);
            load = 0;
            @(posedge clock);
            @(posedge clock);
            #1;
            #1;

            check_outputs(13'h1F02);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Reset priority over Load", test_num);
            reset_dut();
            rst = 1;
            load = 1;
            ir_addr = 13'h1AAA;
            @(posedge clock);
            #1;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Load priority over Increment", test_num);
            reset_dut();
            @(posedge clock);
            ir_addr = 13'h0555;
            load = 1;
            @(posedge clock);
            #1;
            #1;

            check_outputs(13'h0555);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: 13-bit Wrap-around", test_num);
            reset_dut();
            ir_addr = 13'h1FFF;
            load = 1;
            @(posedge clock);
            load = 0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: High-order bit check", test_num);
            reset_dut();
            ir_addr = 13'h1000;
            load = 1;
            @(posedge clock);
            load = 0;
            repeat(5) @(posedge clock);
            #1;
            #1;

            check_outputs(13'h1005);
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
        input [12:0] expected_pc_addr;
        begin
            if (expected_pc_addr === (expected_pc_addr ^ pc_addr ^ expected_pc_addr)) begin
                $display("PASS");
                $display("  Outputs: pc_addr=%h",
                         pc_addr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_addr=%h",
                         expected_pc_addr);
                $display("  Got:      pc_addr=%h",
                         pc_addr);
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
        $dumpvars(0,clock, ir_addr, load, rst, pc_addr);
    end

endmodule
