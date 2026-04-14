`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] bus;
    reg clk;
    reg [15:0] ea;
    reg en;
    reg load_pc;
    reg [1:0] pc_sel;
    reg reset;
    wire [15:0] pc_out;
    wire [15:0] pc_ungated;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bus(bus),
        .clk(clk),
        .ea(ea),
        .en(en),
        .load_pc(load_pc),
        .pc_sel(pc_sel),
        .reset(reset),
        .pc_out(pc_out),
        .pc_ungated(pc_ungated)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 0;
        en = 1;
        load_pc = 0;
        pc_sel = 2'b00;
        bus = 16'h0000;
        ea = 16'h0000;

        repeat(2) @(posedge clk);
        #1 reset = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();

        #1;


        check_outputs(16'h0200, 16'h0200);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        pc_sel = 2'b00;
        load_pc = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0202, 16'h0202);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        ea = 16'h1234;
        pc_sel = 2'b01;
        load_pc = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1234, 16'h1234);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        bus = 16'hABCD;
        pc_sel = 2'b10;
        load_pc = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'hABCD, 16'hABCD);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        pc_sel = 2'b11;
        load_pc = 1;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0000, 16'h0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        load_pc = 0;
        pc_sel = 2'b00;
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h0200, 16'h0200);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        reset_dut();
        en = 0;
        #1;

        #1;


        check_outputs(16'hzzzz, 16'h0200);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        reset_dut();

        ea = 16'h1000;
        pc_sel = 2'b01;
        load_pc = 1;
        @(posedge clk);
        #1;

        pc_sel = 2'b00;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(16'h1004, 16'h1004);
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
        input [15:0] expected_pc_out;
        input [15:0] expected_pc_ungated;
        begin
            if (expected_pc_out === (expected_pc_out ^ pc_out ^ expected_pc_out) &&
                expected_pc_ungated === (expected_pc_ungated ^ pc_ungated ^ expected_pc_ungated)) begin
                $display("PASS");
                $display("  Outputs: pc_out=%h, pc_ungated=%h",
                         pc_out, pc_ungated);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pc_out=%h, pc_ungated=%h",
                         expected_pc_out, expected_pc_ungated);
                $display("  Got:      pc_out=%h, pc_ungated=%h",
                         pc_out, pc_ungated);
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
        $dumpvars(0,bus, clk, ea, en, load_pc, pc_sel, reset, pc_out, pc_ungated);
    end

endmodule
