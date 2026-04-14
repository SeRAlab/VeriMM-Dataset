`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] addr_a;
    reg [13:0] addr_b;
    reg clk_a;
    reg clk_b;
    reg [8:0] din_a;
    reg [8:0] din_b;
    reg en;
    reg we_a;
    reg we_b;
    wire [8:0] dout_a;
    wire [8:0] dout_b;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr_a(addr_a),
        .addr_b(addr_b),
        .clk_a(clk_a),
        .clk_b(clk_b),
        .din_a(din_a),
        .din_b(din_b),
        .en(en),
        .we_a(we_a),
        .we_b(we_b),
        .dout_a(dout_a),
        .dout_b(dout_b)
    );

    // Clock generation (10ns period)
    initial begin
        clk_a = 0;
        forever #5 clk_a = ~clk_a;
    end

        task reset_dut;

        begin
            en = 0;
            we_a = 0;
            we_b = 0;
            addr_a = 0;
            addr_b = 0;
            din_a = 0;
            din_b = 0;
            repeat (2) @(posedge clk_a);
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Port A Basic Write/Read");
            reset_dut();
            en = 1;

            addr_a = 14'h0010;
            din_a = 9'h1AA;
            we_a = 1;
            @(posedge clk_a);
            #1;

            we_a = 0;
            @(posedge clk_a);
            #2;
            #1;

            check_outputs(9'h1AA, 8'hzz);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Port B Basic Write/Read");
            reset_dut();
            en = 1;

            addr_b = 14'h0020;
            din_b = 9'h055;
            we_b = 1;
            @(posedge clk_b);
            #1;

            we_b = 0;
            @(posedge clk_b);
            #2;
            #1;

            check_outputs(8'hzz, 9'h055);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Cross-Port Check (A Write, B Read)");
            reset_dut();
            en = 1;

            addr_a = 14'h0100;
            din_a = 9'h123;
            we_a = 1;
            @(posedge clk_a);
            #1;
            we_a = 0;

            addr_b = 14'h0100;
            @(posedge clk_b);
            #2;
            #1;

            check_outputs(8'hzz, 9'h123);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Port A Write-First Mode Check");
            reset_dut();
            en = 1;
            addr_a = 14'h0500;
            din_a = 9'h0FF;
            we_a = 1;
            @(posedge clk_a);
            #2;
            #1;

            check_outputs(9'h0FF, 8'hzz);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Port B Write-First Mode Check");
            reset_dut();
            en = 1;
            addr_b = 14'h0600;
            din_b = 9'h1E0;
            we_b = 1;
            @(posedge clk_b);
            #2;
            #1;

            check_outputs(8'hzz, 9'h1E0);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Simultaneous Writes to different addresses");
            reset_dut();
            en = 1;

            addr_a = 14'h0001; din_a = 9'h001; we_a = 1;

            addr_b = 14'h0002; din_b = 9'h002; we_b = 1;

            fork
                @(posedge clk_a);
                @(posedge clk_b);
            join
            #1;
            we_a = 0; we_b = 0;


            addr_a = 14'h0001;
            addr_b = 14'h0002;
            fork
                @(posedge clk_a);
                @(posedge clk_b);
            join
            #2;
            #1;

            check_outputs(9'h001, 9'h002);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Global Enable (en) Check");
            reset_dut();
            en = 0;
            addr_a = 14'h0700;
            din_a = 9'h1FF;
            we_a = 1;
            @(posedge clk_a);
            #1;

            en = 1;
            we_a = 0;
            addr_a = 14'h0700;
            @(posedge clk_a);
            #2;

            if (dout_a !== 9'h1FF) begin
                 $display("PASS: Data was not written when en=0");
                 pass_count = pass_count + 1;
            end else begin
                 $display("FAIL: Data was written despite en=0");
                 fail_count = fail_count + 1;
            end
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
        testcase007();
        
        
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
        input [8:0] expected_dout_a;
        input [8:0] expected_dout_b;
        begin
            if (expected_dout_a === (expected_dout_a ^ dout_a ^ expected_dout_a) &&
                expected_dout_b === (expected_dout_b ^ dout_b ^ expected_dout_b)) begin
                $display("PASS");
                $display("  Outputs: dout_a=%h, dout_b=%h",
                         dout_a, dout_b);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout_a=%h, dout_b=%h",
                         expected_dout_a, expected_dout_b);
                $display("  Got:      dout_a=%h, dout_b=%h",
                         dout_a, dout_b);
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
        $dumpvars(0,addr_a, addr_b, clk_a, clk_b, din_a, din_b, en, we_a, we_b, dout_a, dout_b);
    end

endmodule
