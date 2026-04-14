`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr0;
    reg [9:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [31:0] d0;
    reg we0;
    wire [31:0] q0;
    wire [31:0] q1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr0(addr0),
        .addr1(addr1),
        .ce0(ce0),
        .ce1(ce1),
        .clk(clk),
        .d0(d0),
        .we0(we0),
        .q0(q0),
        .q1(q1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr0 = 0;
            addr1 = 0;
            ce0 = 0;
            ce1 = 0;
            d0 = 0;
            we0 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running testcase001: Basic Port 0 R/W...");

            addr0 = 10'h10;
            ce0 = 1;
            we0 = 1;
            d0 = 32'hABCDE001;
            @(posedge clk);
            #1;

            we0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hABCDE001, 32'hx);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running testcase002: Port 0 Write, Port 1 Read...");

            addr0 = 10'h3FF;
            ce0 = 1;
            we0 = 1;
            d0 = 32'h5555AAAA;
            @(posedge clk);
            #1;

            ce0 = 0;
            we0 = 0;
            addr1 = 10'h3FF;
            ce1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hx, 32'h5555AAAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running testcase003: Dual Port Simultaneous Read...");

            addr0 = 10'hA; ce0 = 1; we0 = 1; d0 = 32'h11111111;
            @(posedge clk); #1;
            addr0 = 10'hB; ce0 = 1; we0 = 1; d0 = 32'h22222222;
            @(posedge clk); #1;


            we0 = 0;
            addr0 = 10'hA;
            addr1 = 10'hB;
            ce0 = 1;
            ce1 = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h11111111, 32'h22222222);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running testcase004: Write Enable Check...");

            addr0 = 10'h50; ce0 = 1; we0 = 1; d0 = 32'hDEADBEEF;
            @(posedge clk); #1;


            addr0 = 10'h50; ce0 = 1; we0 = 0; d0 = 32'hCAFEBABE;
            @(posedge clk); #1;


            addr0 = 10'h50; ce0 = 1; we0 = 0;
            @(posedge clk); #1;
            #1;

            check_outputs(32'hDEADBEEF, 32'hx);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running testcase005: Chip Enable Check...");

            addr0 = 10'h100; ce0 = 1; we0 = 1; d0 = 32'h99998888;
            @(posedge clk); #1;




            ce0 = 0; we0 = 1; d0 = 32'h00000000;
            @(posedge clk); #1;


            ce0 = 1; we0 = 0; addr0 = 10'h100;
            @(posedge clk); #1;
            #1;

            check_outputs(32'h99998888, 32'hx);
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
        input [31:0] expected_q0;
        input [31:0] expected_q1;
        begin
            if (expected_q0 === (expected_q0 ^ q0 ^ expected_q0) &&
                expected_q1 === (expected_q1 ^ q1 ^ expected_q1)) begin
                $display("PASS");
                $display("  Outputs: q0=%h, q1=%h",
                         q0, q1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q0=%h, q1=%h",
                         expected_q0, expected_q1);
                $display("  Got:      q0=%h, q1=%h",
                         q0, q1);
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d0, we0, q0, q1);
    end

endmodule
