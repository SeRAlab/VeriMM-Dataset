`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr0;
    reg [4:0] addr1;
    reg [4:0] addr2;
    reg clk;
    reg [31:0] wd;
    reg we;
    wire [31:0] rd0;
    wire [31:0] rd1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .wd(wd),
        .we(we),
        .rd0(rd0),
        .rd1(rd1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            we = 1;
            for (i = 0; i < 32; i = i + 1) begin
                addr2 = i;
                wd = 32'h0;
                @(negedge clk);
            end
            we = 0;
            addr0 = 0;
            addr1 = 0;
            addr2 = 0;
            wd = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Register 0 hardwired to zero check");
            @(negedge clk);
            we = 1;
            addr2 = 5'd0;
            wd = 32'hFFFFFFFF;
            @(negedge clk);
            we = 0;
            addr0 = 5'd0;
            addr1 = 5'd0;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Basic Write and Read");
            @(negedge clk);
            we = 1;
            addr2 = 5'd10;
            wd = 32'hA5A5A5A5;
            @(negedge clk);
            we = 0;
            addr0 = 5'd10;
            addr1 = 5'd0;
            #2;
            #1;

            check_outputs(32'hA5A5A5A5, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            $display("Testcase 003: Dual Port Read");

            @(negedge clk);
            we = 1;
            addr2 = 5'd5;
            wd = 32'h11112222;

            @(negedge clk);
            addr2 = 5'd20;
            wd = 32'h33334444;
            @(negedge clk);
            we = 0;
            addr0 = 5'd5;
            addr1 = 5'd20;
            #2;
            #1;

            check_outputs(32'h11112222, 32'h33334444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            $display("Testcase 004: Write Enable check");
            @(negedge clk);
            we = 0;
            addr2 = 5'd15;
            wd = 32'hDEADBEEF;
            @(negedge clk);
            addr0 = 5'd15;
            addr1 = 5'd15;
            #2;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            $display("Testcase 005: Highest Address (31) check");
            @(negedge clk);
            we = 1;
            addr2 = 5'd31;
            wd = 32'h87654321;
            @(negedge clk);
            we = 0;
            addr0 = 5'd31;
            addr1 = 5'd0;
            #2;
            #1;

            check_outputs(32'h87654321, 32'h0);
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
        input [31:0] expected_rd0;
        input [31:0] expected_rd1;
        begin
            if (expected_rd0 === (expected_rd0 ^ rd0 ^ expected_rd0) &&
                expected_rd1 === (expected_rd1 ^ rd1 ^ expected_rd1)) begin
                $display("PASS");
                $display("  Outputs: rd0=%h, rd1=%h",
                         rd0, rd1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd0=%h, rd1=%h",
                         expected_rd0, expected_rd1);
                $display("  Got:      rd0=%h, rd1=%h",
                         rd0, rd1);
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
        $dumpvars(0,addr0, addr1, addr2, clk, wd, we, rd0, rd1);
    end

endmodule
