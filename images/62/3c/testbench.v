`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg [31:0] mem_addr;
    reg mem_instr;
    reg mem_valid;
    reg [31:0] mem_wdata;
    reg [3:0] mem_wstrb;
    reg resetn;
    wire [31:0] mem_rdata;
    wire mem_ready;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .enable(enable),
        .mem_addr(mem_addr),
        .mem_instr(mem_instr),
        .mem_valid(mem_valid),
        .mem_wdata(mem_wdata),
        .mem_wstrb(mem_wstrb),
        .resetn(resetn),
        .mem_rdata(mem_rdata),
        .mem_ready(mem_ready)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        resetn = 0;
        enable = 0;
        mem_valid = 0;
        mem_instr = 0;
        mem_wstrb = 0;
        mem_wdata = 0;
        mem_addr = 0;
        #20;
        resetn = 1;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Reset and Disable High-Impedance Check", test_num);


        resetn = 0;
        enable = 1;
        #10;
        #1;

        check_outputs(32'bz, 1'bz);


        resetn = 1;
        enable = 0;
        #10;
        #1;

        check_outputs(32'bz, 1'bz);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Basic Counting (5 Negative Edges)", test_num);
        reset_dut();

        enable = 1;
        mem_valid = 1;



        repeat(5) @(negedge clk);
        #2;


        #1;



        check_outputs(32'd5, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Memory Ready/Valid Logic", test_num);
        reset_dut();

        enable = 1;
        mem_valid = 0;
        #15;





        @(negedge clk);
        mem_valid = 0;
        #2;
        #1;

        check_outputs(32'd1, 1'b0);

        mem_valid = 1;
        #1;
        #1;

        check_outputs(32'd1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Counter persistence while module disabled", test_num);
        reset_dut();

        enable = 0;

        repeat(10) @(negedge clk);


        enable = 1;
        mem_valid = 1;
        #2;
        #1;

        check_outputs(32'd10, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Long duration counting", test_num);
        reset_dut();

        enable = 1;
        mem_valid = 1;

        repeat(100) @(negedge clk);
        #2;
        #1;

        check_outputs(32'd100, 1'b1);
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
        input [31:0] expected_mem_rdata;
        input expected_mem_ready;
        begin
            if (expected_mem_rdata === (expected_mem_rdata ^ mem_rdata ^ expected_mem_rdata) &&
                expected_mem_ready === (expected_mem_ready ^ mem_ready ^ expected_mem_ready)) begin
                $display("PASS");
                $display("  Outputs: mem_rdata=%h, mem_ready=%b",
                         mem_rdata, mem_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_rdata=%h, mem_ready=%b",
                         expected_mem_rdata, expected_mem_ready);
                $display("  Got:      mem_rdata=%h, mem_ready=%b",
                         mem_rdata, mem_ready);
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
        $dumpvars(0,clk, enable, mem_addr, mem_instr, mem_valid, mem_wdata, mem_wstrb, resetn, mem_rdata, mem_ready);
    end

endmodule
