`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [13:0] a;
    reg clk;
    reg [31:0] d;
    reg ena;
    reg w;
    reg [3:0] wb;
    wire [31:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .ena(ena),
        .w(w),
        .wb(wb),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ena = 0;
            w = 0;
            wb = 4'b0000;
            a = 14'b0;
            d = 32'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase 001: Full word write to RAM address 0x0000");

            @(negedge clk);
            ena = 1;
            w = 1;
            wb = 4'hF;
            a = 14'h0000;
            d = 32'hDEADBEEF;

            @(negedge clk);
            w = 0;

            @(negedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase 002: Partial byte-write to RAM address 0x0010");


            @(negedge clk);
            ena = 1; w = 1; wb = 4'hF; a = 14'h0010; d = 32'hFFFFFFFF;


            @(negedge clk);
            wb = 4'b0101;
            d = 32'h11BB22AA;

            @(negedge clk);
            w = 0;

            @(negedge clk);
            #1;

            #1;


            check_outputs(32'hFFBBFFAA);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase 003: Verify 'ena' signal disables writes");


            @(negedge clk);
            ena = 0; w = 1; wb = 4'hF; a = 14'h0020; d = 32'hCAFEFACE;

            @(negedge clk);
            ena = 1; w = 0; a = 14'h0020;

            @(negedge clk);
            #1;

            if (q !== 32'hCAFEFACE) begin
                pass_count = pass_count + 1;
                $display("PASS: Write ignored when ena=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Write occurred despite ena=0");
            end
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase 004: Sequential writes to multiple RAM addresses");

            @(negedge clk);
            ena = 1; w = 1; wb = 4'hF;
            a = 14'h0001; d = 32'h11111111;
            @(negedge clk);
            a = 14'h0002; d = 32'h22222222;
            @(negedge clk);
            a = 14'h0003; d = 32'h33333333;

            @(negedge clk);
            w = 0; a = 14'h0002;

            @(negedge clk);
            #1;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase 005: Accessing ROM address range (0x2000)");

            @(negedge clk);
            ena = 1; w = 0; a = 14'h2000;

            @(negedge clk);
            #1;


            if (q !== 32'hx) begin
                $display("PASS: ROM Address 0x2000 accessed, Value: %h", q);
                pass_count = pass_count + 1;
            } else begin
                $display("FAIL: ROM Address 0x2000 returned X");
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
        input [31:0] expected_q;
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
        $dumpvars(0,a, clk, d, ena, w, wb, q);
    end

endmodule
