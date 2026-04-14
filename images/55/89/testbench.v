`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addr;
    reg clk;
    reg [31:0] din;
    reg we;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .we(we),
        .dout(dout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        addr <= 0;
        din <= 0;
        we <= 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running Testcase 001: Basic Write and Read back...");
        reset_dut();

        addr <= 14'h0005;
        din <= 32'hDEADBEEF;
        we <= 1;
        @(posedge clk);

        we <= 0;
        addr <= 14'h0005;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        $display("Running Testcase 002: Minimum Address (0) Check...");
        reset_dut();
        addr <= 14'h0000;
        din <= 32'h12345678;
        we <= 1;
        @(posedge clk);
        we <= 0;
        addr <= 14'h0000;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        $display("Running Testcase 003: Maximum Address (16383) Check...");
        reset_dut();
        addr <= 14'h3FFF;
        din <= 32'hAAAA5555;
        we <= 1;
        @(posedge clk);
        we <= 0;
        addr <= 14'h3FFF;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'hAAAA5555);
    end
        endtask

    task testcase004;

    begin
        $display("Running Testcase 004: Write Enable (WE) Control Check...");
        reset_dut();

        addr <= 14'h0010;
        din <= 32'h11111111;
        we <= 1;
        @(posedge clk);

        addr <= 14'h0010;
        din <= 32'hFFFFFFFF;
        we <= 0;
        @(posedge clk);

        addr <= 14'h0010;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h11111111);
    end
        endtask

    task testcase005;

    begin
        $display("Running Testcase 005: Data Overwrite Check...");
        reset_dut();

        addr <= 14'h0100;
        din <= 32'h00000001;
        we <= 1;
        @(posedge clk);

        addr <= 14'h0100;
        din <= 32'h00000002;
        we <= 1;
        @(posedge clk);

        we <= 0;
        addr <= 14'h0100;
        @(posedge clk);
        #2;
        #1;

        check_outputs(32'h00000002);
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
        input [31:0] expected_dout;
        begin
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
        $dumpvars(0,addr, clk, din, we, dout);
    end

endmodule
