`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [31:0] address;
    reg clk;
    reg mem_write;
    reg [31:0] write_data;
    wire [31:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .mem_write(mem_write),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        address = 0;
        mem_write = 0;
        write_data = 0;
        repeat (2) @(posedge clk);
    end
        endtask
    task testcase001;

    begin
        reset_dut();
        test_num = 1;
        $display("Running Testcase 001: Basic Write/Read Address 0");
        @(negedge clk);
        address = 32'h00000000;
        write_data = 32'hDEADBEEF;
        mem_write = 1;
        @(negedge clk);
        mem_write = 0;

        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        reset_dut();
        test_num = 2;
        $display("Running Testcase 002: Write/Read Address 4");
        @(negedge clk);
        address = 32'h00000004;
        write_data = 32'h12345678;
        mem_write = 1;
        @(negedge clk);
        mem_write = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        reset_dut();
        test_num = 3;
        $display("Running Testcase 003: Write Enable Verification");

        @(negedge clk);
        address = 32'h00000008;
        write_data = 32'hAAAA_AAAA;
        mem_write = 1;
        @(negedge clk);

        write_data = 32'hFFFF_FFFF;
        mem_write = 0;
        @(negedge clk);

        address = 32'h00000008;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hAAAA_AAAA);
    end
        endtask

    task testcase004;

    begin
        reset_dut();
        test_num = 4;
        $display("Running Testcase 004: Data Persistence Across Addresses");

        @(negedge clk);
        address = 32'h0000000C;
        write_data = 32'h1111_2222;
        mem_write = 1;
        @(negedge clk);

        address = 32'h00000010;
        write_data = 32'h3333_4444;
        mem_write = 1;
        @(negedge clk);
        mem_write = 0;

        address = 32'h0000000C;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h1111_2222);
    end
        endtask

    task testcase005;

    begin
        reset_dut();
        test_num = 5;
        $display("Running Testcase 005: All-Ones Data Test");
        @(negedge clk);
        address = 32'h00000020;
        write_data = 32'hFFFF_FFFF;
        mem_write = 1;
        @(negedge clk);
        mem_write = 0;
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hFFFF_FFFF);
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
        input [31:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,address, clk, mem_write, write_data, read_data);
    end

endmodule
