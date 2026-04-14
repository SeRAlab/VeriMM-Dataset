`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] mem_rdata;
    reg mem_ready;
    reg resetn;
    reg tick;
    wire [31:0] mem_addr;
    wire mem_instr;
    wire mem_valid;
    wire [31:0] mem_wdata;
    wire [3:0] mem_wstrb;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready),
        .resetn(resetn),
        .tick(tick),
        .mem_addr(mem_addr),
        .mem_instr(mem_instr),
        .mem_valid(mem_valid),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetn = 0;
            tick = 0;
            mem_ready = 1;
            mem_rdata = 32'h0;
            @(posedge clk);
            #2 resetn = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(32'hffff0060, 0, 0, 32'h0, 4'hf);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: First Tick Memory Access", test_num);
            reset_dut();
            @(posedge clk);
            tick = 1;
            #2;

            #1;


            check_outputs(32'hffff0060, 0, 1, 32'h0, 4'hf);
            @(posedge clk);
            tick = 0;
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %0d: Counter Increment (5th tick)", test_num);
            reset_dut();
            for (i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                tick = 1;
                @(posedge clk);
                tick = 0;
            end

            @(posedge clk);
            tick = 1;
            #2;

            #1;


            check_outputs(32'hffff0060, 0, 1, 32'h4, 4'hf);
            @(posedge clk);
            tick = 0;
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Counter Wrap Around (17th tick)", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                @(posedge clk);
                tick = 1;
                @(posedge clk);
                tick = 0;
            end

            @(posedge clk);
            tick = 1;
            #2;
            #1;

            check_outputs(32'hffff0060, 0, 1, 32'h0, 4'hf);
            @(posedge clk);
            tick = 0;
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: De-activated Tick State", test_num);
            reset_dut();
            @(posedge clk);
            tick = 1;
            @(posedge clk);
            tick = 0;
            #2;

            #1;


            check_outputs(32'hffff0060, 0, 0, 32'h1, 4'hf);
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
        input [31:0] expected_mem_addr;
        input expected_mem_instr;
        input expected_mem_valid;
        input [31:0] expected_mem_wdata;
        input [3:0] expected_mem_wstrb;
        begin
            if (expected_mem_addr === (expected_mem_addr ^ mem_addr ^ expected_mem_addr) &&
                expected_mem_instr === (expected_mem_instr ^ mem_instr ^ expected_mem_instr) &&
                expected_mem_valid === (expected_mem_valid ^ mem_valid ^ expected_mem_valid) &&
                expected_mem_wdata === (expected_mem_wdata ^ mem_wdata ^ expected_mem_wdata) &&
                expected_mem_wstrb === (expected_mem_wstrb ^ mem_wstrb ^ expected_mem_wstrb)) begin
                $display("PASS");
                $display("  Outputs: mem_addr=%h, mem_instr=%b, mem_valid=%b, mem_wdata=%h, mem_wstrb=%h",
                         mem_addr, mem_instr, mem_valid, mem_wdata, mem_wstrb);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_addr=%h, mem_instr=%b, mem_valid=%b, mem_wdata=%h, mem_wstrb=%h",
                         expected_mem_addr, expected_mem_instr, expected_mem_valid, expected_mem_wdata, expected_mem_wstrb);
                $display("  Got:      mem_addr=%h, mem_instr=%b, mem_valid=%b, mem_wdata=%h, mem_wstrb=%h",
                         mem_addr, mem_instr, mem_valid, mem_wdata, mem_wstrb);
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
        $dumpvars(0,clk, mem_rdata, mem_ready, resetn, tick, mem_addr, mem_instr, mem_valid, mem_wdata, mem_wstrb);
    end

endmodule
