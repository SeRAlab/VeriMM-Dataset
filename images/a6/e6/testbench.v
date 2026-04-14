`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg [31:0] data;
    reg we;
    wire [31:0] mem_data;
    wire mem_re;
    wire mem_we;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .data(data),
        .we(we),
        .mem_data(mem_data),
        .mem_re(mem_re),
        .mem_we(mem_we)
    );

        task reset_dut;

    begin
        rst_n = 0;
        we = 0;
        addr = 0;
        data = 0;
        @(posedge clk);
        #2 rst_n = 1;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        we = 1;
        addr = 8'hA5;
        data = 32'hDEADBEEF;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF, 1'b0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        we = 0;
        addr = 8'h10;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        we = 0;
        addr = 8'h20;
        @(posedge clk);
        @(posedge clk);
        #1;

        #1;


        check_outputs(32'h0, 1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        we = 1;
        addr = 8'hFF;
        data = 32'hCAFEFACE;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h0, 1'b0, 1'b0);
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
        input [31:0] expected_mem_data;
        input expected_mem_re;
        input expected_mem_we;
        begin
            if (expected_mem_data === (expected_mem_data ^ mem_data ^ expected_mem_data) &&
                expected_mem_re === (expected_mem_re ^ mem_re ^ expected_mem_re) &&
                expected_mem_we === (expected_mem_we ^ mem_we ^ expected_mem_we)) begin
                $display("PASS");
                $display("  Outputs: mem_data=%h, mem_re=%b, mem_we=%b",
                         mem_data, mem_re, mem_we);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: mem_data=%h, mem_re=%b, mem_we=%b",
                         expected_mem_data, expected_mem_re, expected_mem_we);
                $display("  Got:      mem_data=%h, mem_re=%b, mem_we=%b",
                         mem_data, mem_re, mem_we);
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
        $dumpvars(0,addr, data, we, mem_data, mem_re, mem_we);
    end

endmodule
