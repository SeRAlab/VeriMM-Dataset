`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [8:0] rom_addr;
    reg [25:0] rom_q;
    wire done;
    wire [10:0] pe;
    wire [5:0] ram_a_addr;
    wire [5:0] ram_b_addr;
    wire ram_b_w;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .reset(reset),
        .rom_addr(rom_addr),
        .rom_q(rom_q),
        .done(done),
        .pe(pe),
        .ram_a_addr(ram_a_addr),
        .ram_b_addr(ram_b_addr),
        .ram_b_w(ram_b_w)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            rom_addr = 0;
            rom_q = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            rom_q = {2'b00, 6'd20, 6'd10, 6'd5, 6'd0};
            wait(done == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 11'd15, 6'd10, 6'd20, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            rom_q = {2'b01, 6'd30, 6'd25, 6'd7, 6'd0};
            wait(done == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 11'd18, 6'd25, 6'd30, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            rom_q = {2'b10, 6'd40, 6'd6, 6'd0, 6'd0};
            wait(done == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 11'd216, 6'd6, 6'd40, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            rom_q = {2'b11, 6'd50, 6'd12, 6'd9, 6'd0};
            wait(done == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 11'd108, 6'd12, 6'd50, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            rom_q = {2'b00, 6'd10, 6'd2, 6'd3, 6'd2};
            wait(done == 1);
            @(posedge clk);
            #1 #1;
 check_outputs(1'b1, 11'd9, 6'd4, 6'd12, 1'b0);
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
        input expected_done;
        input [10:0] expected_pe;
        input [5:0] expected_ram_a_addr;
        input [5:0] expected_ram_b_addr;
        input expected_ram_b_w;
        begin
            if (expected_done === (expected_done ^ done ^ expected_done) &&
                expected_pe === (expected_pe ^ pe ^ expected_pe) &&
                expected_ram_a_addr === (expected_ram_a_addr ^ ram_a_addr ^ expected_ram_a_addr) &&
                expected_ram_b_addr === (expected_ram_b_addr ^ ram_b_addr ^ expected_ram_b_addr) &&
                expected_ram_b_w === (expected_ram_b_w ^ ram_b_w ^ expected_ram_b_w)) begin
                $display("PASS");
                $display("  Outputs: done=%b, pe=%h, ram_a_addr=%h, ram_b_addr=%h, ram_b_w=%b",
                         done, pe, ram_a_addr, ram_b_addr, ram_b_w);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: done=%b, pe=%h, ram_a_addr=%h, ram_b_addr=%h, ram_b_w=%b",
                         expected_done, expected_pe, expected_ram_a_addr, expected_ram_b_addr, expected_ram_b_w);
                $display("  Got:      done=%b, pe=%h, ram_a_addr=%h, ram_b_addr=%h, ram_b_w=%b",
                         done, pe, ram_a_addr, ram_b_addr, ram_b_w);
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
        $dumpvars(0,clk, reset, rom_addr, rom_q, done, pe, ram_a_addr, ram_b_addr, ram_b_w);
    end

endmodule
