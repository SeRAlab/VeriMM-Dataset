`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [4:0] raddr1;
    reg [4:0] raddr2;
    reg rst;
    reg w_en;
    reg [4:0] waddr;
    reg [31:0] wdata;
    wire [31:0] rdata1;
    wire [31:0] rdata2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .raddr1(raddr1),
        .raddr2(raddr2),
        .rst(rst),
        .w_en(w_en),
        .waddr(waddr),
        .wdata(wdata),
        .rdata1(rdata1),
        .rdata2(rdata2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            w_en = 0;
            waddr = 0;
            wdata = 0;
            raddr1 = 0;
            raddr2 = 0;
            @(posedge clk);
            #2 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset State Check");
            test_num = 1;
            reset_dut();
            raddr1 = 5'd0;
            raddr2 = 5'd31;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Single Write and Dual Read");
            test_num = 2;
            reset_dut();
            @(negedge clk);
            w_en = 1;
            waddr = 5'd10;
            wdata = 32'hDEADBEEF;
            @(posedge clk);
            #1 w_en = 0;
            raddr1 = 5'd10;
            raddr2 = 5'd10;
            #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hDEADBEEF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Check");
            test_num = 3;
            reset_dut();
            @(negedge clk);
            w_en = 0;
            waddr = 5'd15;
            wdata = 32'hFFFFFFFF;
            @(posedge clk);
            #1 raddr1 = 5'd15;
            raddr2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Multiple Registers Check");
            test_num = 4;
            reset_dut();

            @(negedge clk);
            w_en = 1; waddr = 5'd1; wdata = 32'h11111111;
            @(posedge clk);

            @(negedge clk);
            waddr = 5'd2; wdata = 32'h22222222;
            @(posedge clk);
            #1 w_en = 0;
            raddr1 = 5'd1;
            raddr2 = 5'd2;
            #1;
            #1;

            check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwrite Check");
            test_num = 5;
            reset_dut();
            @(negedge clk);
            w_en = 1; waddr = 5'd7; wdata = 32'hAAAA_AAAA;
            @(posedge clk);
            @(negedge clk);
            wdata = 32'h5555_5555;
            @(posedge clk);
            #1 w_en = 0;
            raddr1 = 5'd7;
            raddr2 = 5'd0;
            #1;
            #1;

            check_outputs(32'h5555_5555, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Boundary Address Check");
            test_num = 6;
            reset_dut();
            @(negedge clk);
            w_en = 1; waddr = 5'd0; wdata = 32'h0000_0001;
            @(posedge clk);
            @(negedge clk);
            waddr = 5'd31; wdata = 32'h8000_0000;
            @(posedge clk);
            #1 w_en = 0;
            raddr1 = 5'd0;
            raddr2 = 5'd31;
            #1;
            #1;

            check_outputs(32'h0000_0001, 32'h8000_0000);
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
        input [31:0] expected_rdata1;
        input [31:0] expected_rdata2;
        begin
            if (expected_rdata1 === (expected_rdata1 ^ rdata1 ^ expected_rdata1) &&
                expected_rdata2 === (expected_rdata2 ^ rdata2 ^ expected_rdata2)) begin
                $display("PASS");
                $display("  Outputs: rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rdata1=%h, rdata2=%h",
                         expected_rdata1, expected_rdata2);
                $display("  Got:      rdata1=%h, rdata2=%h",
                         rdata1, rdata2);
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
        $dumpvars(0,clk, raddr1, raddr2, rst, w_en, waddr, wdata, rdata1, rdata2);
    end

endmodule
