`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [9:0] addr;
    reg clk;
    reg [15:0] din;
    reg en;
    reg we;
    wire [15:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .din(din),
        .en(en),
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
            en = 0;
            we = 0;
            addr = 0;
            din = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Write and Read", test_num);
            reset_dut();


            @(posedge clk);
            #1;
            en = 1; we = 1; addr = 10'h001; din = 16'hABCD;
            @(posedge clk);
            #1;


            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hABCD);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Write-Through Check", test_num);
            reset_dut();


            @(posedge clk);
            #1;
            en = 1; we = 1; addr = 10'h005; din = 16'h55AA;


            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h55AA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Memory Persistence and Overwrite", test_num);
            reset_dut();


            @(posedge clk); #1;
            en = 1; we = 1; addr = 10'h00A; din = 16'h1111;
            @(posedge clk); #1;


            addr = 10'h00B; din = 16'h2222;
            @(posedge clk); #1;


            addr = 10'h00A; din = 16'h3333;
            @(posedge clk); #1;


            we = 0; addr = 10'h00A;
            @(posedge clk); #1;

            #1;


            check_outputs(16'h3333);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: WE Gating Check", test_num);
            reset_dut();


            @(posedge clk); #1;
            en = 1; we = 1; addr = 10'h014; din = 16'h7777;
            @(posedge clk); #1;


            we = 0; din = 16'hEEEE;
            @(posedge clk); #1;


            @(posedge clk); #1;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: EN Gating Check", test_num);
            reset_dut();


            @(posedge clk); #1;
            en = 0; we = 1; addr = 10'h01E; din = 16'h9999;
            @(posedge clk); #1;


            en = 1; we = 0;
            @(posedge clk); #1;


            if (dout !== 16'h9999) begin
                pass_count = pass_count + 1;
                $display("PASS: Data 0x9999 was not written because en=0");
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Data 0x9999 was written despite en=0");
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
        input [15:0] expected_dout;
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
        $dumpvars(0,addr, clk, din, en, we, dout);
    end

endmodule
