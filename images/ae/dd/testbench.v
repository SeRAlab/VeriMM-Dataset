`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg en;
    reg w;
    reg [3:0] wbe;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .en(en),
        .w(w),
        .wbe(wbe),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        en = 0;
        w = 0;
        wbe = 0;
        addr = 0;
        data_in = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Testcase 001: RAM Full Word Write and Read at addr 0x0000");
        reset_dut();
        test_num = 1;

        en = 1; w = 1; wbe = 4'b1111; addr = 14'h0000; data_in = 32'hDEADBEEF;
        @(posedge clk);

        w = 0; addr = 14'h0000;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hDEADBEEF);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: RAM Byte Enable (Updating middle bytes)");
        reset_dut();
        test_num = 2;

        en = 1; w = 1; wbe = 4'b1111; addr = 14'h0004; data_in = 32'h00000000;
        @(posedge clk);

        wbe = 4'b0110; data_in = 32'h00AA5500;
        @(posedge clk);

        w = 0; wbe = 4'b1111; addr = 14'h0004;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00AA5500);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: RAM Byte Enable (Updating byte 0 and 3)");
        reset_dut();
        test_num = 3;

        en = 1; w = 1; wbe = 4'b1111; addr = 14'h0008; data_in = 32'hFFFFFFFF;
        @(posedge clk);

        wbe = 4'b1001; data_in = 32'h00000000;
        @(posedge clk);

        w = 0; wbe = 4'b1111; addr = 14'h0008;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00FFFF00);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Verify data is not written when w=0");
        reset_dut();
        test_num = 4;

        en = 1; w = 1; wbe = 4'b1111; addr = 14'h0010; data_in = 32'hA5A5A5A5;
        @(posedge clk);

        w = 0; data_in = 32'h5A5A5A5A;
        @(posedge clk);

        addr = 14'h0010;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'hA5A5A5A5);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Verify data is not written when en=0");
        reset_dut();
        test_num = 5;

        en = 1; w = 1; wbe = 4'b1111; addr = 14'h0014; data_in = 32'h11223344;
        @(posedge clk);

        en = 0; w = 1; data_in = 32'h99887766;
        @(posedge clk);

        en = 1; w = 0; addr = 14'h0014;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h11223344);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Verify independent addressing of RAM locations");
        reset_dut();
        test_num = 6;

        en = 1; w = 1; wbe = 4'b1111; addr = 14'h0100; data_in = 32'h00000001;
        @(posedge clk);

        addr = 14'h0200; data_in = 32'h00000002;
        @(posedge clk);

        w = 0; addr = 14'h0100;
        @(posedge clk);
        @(posedge clk);
        #1;
        #1;

        check_outputs(32'h00000001);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, en, w, wbe, data_out);
    end

endmodule
