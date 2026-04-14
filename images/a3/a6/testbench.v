`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg trigger;
    wire [15:0] counter;
    wire [14:0] simu_ram_wr_addr;
    wire simu_ram_wr_req;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .trigger(trigger),
        .counter(counter),
        .simu_ram_wr_addr(simu_ram_wr_addr),
        .simu_ram_wr_req(simu_ram_wr_req)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        trigger = 0;
        @(posedge clk);
        #1;
        reset = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(16'd0, 15'd0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        @(negedge clk);
        trigger = 1;
        repeat(10) @(posedge clk);
        @(negedge clk);
        trigger = 0;

        #1;


        check_outputs(16'd10, 15'd10, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        @(negedge clk);
        trigger = 1;
        @(posedge clk);
        @(negedge clk);
        trigger = 0;

        #1;


        check_outputs(16'd1, 15'd1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        @(negedge clk);
        trigger = 1;
        repeat(5) @(posedge clk);
        @(negedge clk);
        trigger = 0;
        repeat(5) @(posedge clk);
        @(negedge clk);
        trigger = 1;
        repeat(5) @(posedge clk);
        @(negedge clk);
        trigger = 0;
        #1;

        check_outputs(16'd10, 15'd10, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        @(negedge clk);
        trigger = 1;
        repeat(255) @(posedge clk);
        @(negedge clk);
        trigger = 0;
        #1;

        check_outputs(16'd255, 15'd255, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        @(negedge clk);
        trigger = 1;
        repeat(2) @(posedge clk);
        #1;

        #1;


        check_outputs(16'd2, 15'd2, 1'b1);
        @(negedge clk);
        trigger = 0;
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
        input [15:0] expected_counter;
        input [14:0] expected_simu_ram_wr_addr;
        input expected_simu_ram_wr_req;
        begin
            if (expected_counter === (expected_counter ^ counter ^ expected_counter) &&
                expected_simu_ram_wr_addr === (expected_simu_ram_wr_addr ^ simu_ram_wr_addr ^ expected_simu_ram_wr_addr) &&
                expected_simu_ram_wr_req === (expected_simu_ram_wr_req ^ simu_ram_wr_req ^ expected_simu_ram_wr_req)) begin
                $display("PASS");
                $display("  Outputs: counter=%h, simu_ram_wr_addr=%h, simu_ram_wr_req=%b",
                         counter, simu_ram_wr_addr, simu_ram_wr_req);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter=%h, simu_ram_wr_addr=%h, simu_ram_wr_req=%b",
                         expected_counter, expected_simu_ram_wr_addr, expected_simu_ram_wr_req);
                $display("  Got:      counter=%h, simu_ram_wr_addr=%h, simu_ram_wr_req=%b",
                         counter, simu_ram_wr_addr, simu_ram_wr_req);
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
        $dumpvars(0,clk, reset, trigger, counter, simu_ram_wr_addr, simu_ram_wr_req);
    end

endmodule
