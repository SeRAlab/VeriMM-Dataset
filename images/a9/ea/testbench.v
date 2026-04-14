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
    wire [31:0] gpio;
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
        .gpio(gpio),
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
            mem_addr = 0;
            mem_wdata = 0;
            mem_wstrb = 0;
            mem_instr = 0;
            repeat(2) @(posedge clk);
            resetn = 1;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Full 32-bit Write", test_num);
            reset_dut();

            @(posedge clk);
            mem_valid = 1;
            enable = 1;
            mem_wstrb = 4'hf;
            mem_wdata = 32'hDEADBEEF;
            mem_addr = 32'h0;


            do @(posedge clk); while (!mem_ready);


            #1;
            mem_valid = 0;
            enable = 0;
            mem_wstrb = 0;


            #1;



            check_outputs(32'hDEADBEEF, 32'hDEADBEEF, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Read Operation", test_num);
            reset_dut();


            @(posedge clk);
            mem_valid = 1;
            enable = 1;
            mem_wstrb = 4'hf;
            mem_wdata = 32'h12345678;
            do @(posedge clk); while (!mem_ready);


            mem_wstrb = 0;
            mem_wdata = 32'h0;
            do @(posedge clk); while (!mem_ready);

            #1;
            mem_valid = 0;
            enable = 0;


            #1;



            check_outputs(32'h12345678, 32'h12345678, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Byte-wise Write (WSTRB)", test_num);
            reset_dut();


            @(posedge clk);
            mem_valid = 1;
            enable = 1;
            mem_wstrb = 4'hf;
            mem_wdata = 32'hFFFFFFFF;
            do @(posedge clk); while (!mem_ready);


            mem_wstrb = 4'b0001;
            mem_wdata = 32'h000000AA;
            do @(posedge clk); while (!mem_ready);


            mem_wstrb = 4'b0100;
            mem_wdata = 32'h00BB0000;
            do @(posedge clk); while (!mem_ready);

            #1;
            mem_valid = 0;
            enable = 0;
            mem_wstrb = 0;


            #1;



            check_outputs(32'hFFBBFFAA, 32'hFFBBFFAA, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Interface Disable Check", test_num);
            reset_dut();


            @(posedge clk);
            mem_valid = 1;
            enable = 0;
            mem_wstrb = 4'hf;
            mem_wdata = 32'hCAFEFACE;
            repeat(2) @(posedge clk);


            enable = 1;
            mem_valid = 0;
            repeat(2) @(posedge clk);

            #1;

            #1;


            check_outputs(32'h0, 32'h0, 1'b0);
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
        input [31:0] expected_gpio;
        input [31:0] expected_mem_rdata;
        input expected_mem_ready;
        begin
            if (expected_gpio === (expected_gpio ^ gpio ^ expected_gpio) &&
                expected_mem_rdata === (expected_mem_rdata ^ mem_rdata ^ expected_mem_rdata) &&
                expected_mem_ready === (expected_mem_ready ^ mem_ready ^ expected_mem_ready)) begin
                $display("PASS");
                $display("  Outputs: gpio=%h, mem_rdata=%h, mem_ready=%b",
                         gpio, mem_rdata, mem_ready);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: gpio=%h, mem_rdata=%h, mem_ready=%b",
                         expected_gpio, expected_mem_rdata, expected_mem_ready);
                $display("  Got:      gpio=%h, mem_rdata=%h, mem_ready=%b",
                         gpio, mem_rdata, mem_ready);
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
        $dumpvars(0,clk, enable, mem_addr, mem_instr, mem_valid, mem_wdata, mem_wstrb, resetn, gpio, mem_rdata, mem_ready);
    end

endmodule
