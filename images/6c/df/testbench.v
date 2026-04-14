`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [4:0] addr0;
    reg [4:0] addr1;
    reg ce0;
    reg ce1;
    reg clk;
    reg [127:0] d0;
    reg [127:0] d1;
    reg we0;
    reg we1;
    wire [127:0] q0;
    wire [127:0] q1;

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
        .d1(d1),
        .we0(we0),
        .we1(we1),
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
            d1 = 0;
            we0 = 0;
            we1 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            addr0 = 5'h0A;
            d0 = 128'hDEADBEEFCAFEBABE1122334455667788;
            ce0 = 1;
            we0 = 1;
            @(posedge clk);
            #1;

            we0 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'hDEADBEEFCAFEBABE1122334455667788, 128'h0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            addr1 = 5'h1F;
            d1 = 128'hFEDCBA98765432100123456789ABCDEF;
            ce1 = 1;
            we1 = 1;
            @(posedge clk);
            #1;

            we1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h0, 128'hFEDCBA98765432100123456789ABCDEF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            addr0 = 5'h01; d0 = 128'h1; ce0 = 1; we0 = 1;
            addr1 = 5'h02; d1 = 128'h2; ce1 = 1; we1 = 1;
            @(posedge clk);
            #1;

            we0 = 0; we1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'h1, 128'h2);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            addr0 = 5'd15; d0 = 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5; ce0 = 1; we0 = 1;
            @(posedge clk);
            #1;

            we0 = 0;
            addr1 = 5'd15; ce1 = 1; we1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5, 128'hA5A5A5A5A5A5A5A5A5A5A5A5A5A5A5A5);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            addr0 = 5'h05; d0 = 128'hFFFF; ce0 = 0; we0 = 1;
            @(posedge clk);
            #1;

            ce0 = 1; we0 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0, 128'h0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            addr1 = 5'd20; d1 = 128'h7777; ce1 = 1; we1 = 1;
            @(posedge clk);
            #1;

            d1 = 128'h8888; we1 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(128'h0, 128'h7777);
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
        input [127:0] expected_q0;
        input [127:0] expected_q1;
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
        $dumpvars(0,addr0, addr1, ce0, ce1, clk, d0, d1, we0, we1, q0, q1);
    end

endmodule
