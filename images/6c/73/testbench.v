`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg clk;
    reg [15:0] d;
    reg [15:0] we;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 8'h0;
            d = 16'h0;
            we = 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Basic Write/Read Address 0x00", test_num);
            a = 8'h00;
            d = 16'hA5A5;
            we = 16'hFFFF;
            @(posedge clk); #1;
            we = 16'h0000;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hA5A5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Basic Write/Read Address 0xFF", test_num);
            a = 8'hFF;
            d = 16'h5A5A;
            we = 16'hFFFF;
            @(posedge clk); #1;
            we = 16'h0000;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h5A5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Bit-wise Masking (Lower Byte Only)", test_num);

            a = 8'h10; d = 16'h0000; we = 16'hFFFF;
            @(posedge clk); #1;

            d = 16'hFFFF; we = 16'h00FF;
            @(posedge clk); #1;

            we = 16'h0000;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h00FF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Bit-wise Masking (Alternating Bits)", test_num);

            a = 8'h20; d = 16'h0000; we = 16'hFFFF;
            @(posedge clk); #1;

            d = 16'hFFFF; we = 16'hAAAA;
            @(posedge clk); #1;

            we = 16'h0000;
            @(posedge clk); #1;
            #1;

            check_outputs(16'hAAAA);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Address Isolation", test_num);

            a = 8'h30; d = 16'h1234; we = 16'hFFFF;
            @(posedge clk); #1;

            a = 8'h31; d = 16'h5678; we = 16'hFFFF;
            @(posedge clk); #1;

            a = 8'h30; we = 16'h0000;
            @(posedge clk); #1;
            #1;

            check_outputs(16'h1234);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Write Enable = 0 Logic", test_num);

            a = 8'h40; d = 16'hBEEF; we = 16'hFFFF;
            @(posedge clk); #1;

            d = 16'hDEAD; we = 16'h0000;
            @(posedge clk); #1;

            @(posedge clk); #1;
            #1;

            check_outputs(16'hBEEF);
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
        input [15:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,a, clk, d, we, q);
    end

endmodule
