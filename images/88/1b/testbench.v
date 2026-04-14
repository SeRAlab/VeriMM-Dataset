`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] idex_mem_read;
    reg [4:0] idex_rt;
    reg [4:0] rs;
    reg rst;
    reg [4:0] rt;
    wire ifidwrite;
    wire mux_op;
    wire pcwrite;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .idex_mem_read(idex_mem_read),
        .idex_rt(idex_rt),
        .rs(rs),
        .rst(rst),
        .rt(rt),
        .ifidwrite(ifidwrite),
        .mux_op(mux_op),
        .pcwrite(pcwrite)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            idex_mem_read = 0;
            idex_rt = 0;
            rs = 0;
            rt = 0;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Reset State", test_num);
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Normal Op (No Mem Read)", test_num);
            reset_dut();
            idex_mem_read = 4'b0000;
            rs = 5'd10;
            rt = 5'd11;
            idex_rt = 5'd10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hazard Detected (rs match)", test_num);
            reset_dut();
            idex_mem_read = 4'b0001;
            idex_rt = 5'd15;
            rs = 5'd15;
            rt = 5'd20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hazard Detected (rt match)", test_num);
            reset_dut();
            idex_mem_read = 4'b1111;
            idex_rt = 5'd25;
            rs = 5'd10;
            rt = 5'd25;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mem Read Active, No Match", test_num);
            reset_dut();
            idex_mem_read = 4'b0010;
            idex_rt = 5'd05;
            rs = 5'd10;
            rt = 5'd11;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1, 0, 1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Double Match Stall", test_num);
            reset_dut();
            idex_mem_read = 4'b0100;
            idex_rt = 5'd12;
            rs = 5'd12;
            rt = 5'd12;
            @(posedge clk);
            #1;
            #1;

            check_outputs(0, 1, 0);
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
        input expected_ifidwrite;
        input expected_mux_op;
        input expected_pcwrite;
        begin
            if (expected_ifidwrite === (expected_ifidwrite ^ ifidwrite ^ expected_ifidwrite) &&
                expected_mux_op === (expected_mux_op ^ mux_op ^ expected_mux_op) &&
                expected_pcwrite === (expected_pcwrite ^ pcwrite ^ expected_pcwrite)) begin
                $display("PASS");
                $display("  Outputs: ifidwrite=%b, mux_op=%b, pcwrite=%b",
                         ifidwrite, mux_op, pcwrite);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ifidwrite=%b, mux_op=%b, pcwrite=%b",
                         expected_ifidwrite, expected_mux_op, expected_pcwrite);
                $display("  Got:      ifidwrite=%b, mux_op=%b, pcwrite=%b",
                         ifidwrite, mux_op, pcwrite);
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
        $dumpvars(0,clk, idex_mem_read, idex_rt, rs, rst, rt, ifidwrite, mux_op, pcwrite);
    end

endmodule
