`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] address;
    reg clk;
    reg [7:0] din;
    reg re;
    reg we;
    wire [7:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .din(din),
        .re(re),
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
            address = 0;
            din = 0;
            re = 0;
            we = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();

            address = 7'd5;
            din = 8'hA5;
            we = 1;
            re = 0;
            @(posedge clk);

            #1;
            we = 0;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Boundary Write/Read (Address 0)");
            reset_dut();
            address = 7'd0;
            din = 8'hFF;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Boundary Write/Read (Address 69)");
            reset_dut();
            address = 7'd69;
            din = 8'h3C;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting data");
            reset_dut();
            address = 7'd10;
            din = 8'h11;
            we = 1;
            @(posedge clk);
            #1;
            din = 8'h22;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Multiple writes, checking specific address");
            reset_dut();

            address = 7'd20; din = 8'hDE; we = 1; @(posedge clk); #1;

            address = 7'd21; din = 8'hAD; we = 1; @(posedge clk); #1;

            address = 7'd22; din = 8'hBE; we = 1; @(posedge clk); #1;

            we = 0;
            address = 7'd21;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAD);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Data persistence");
            reset_dut();
            address = 7'd40;
            din = 8'h55;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            re = 0;

            repeat(5) @(posedge clk);
            #1;
            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Read Enable functionality");
            reset_dut();
            address = 7'd33;
            din = 8'h88;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            re = 0;
            @(posedge clk);
            #1;


            re = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h88);
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
        input [7:0] expected_dout;
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
        $dumpvars(0,address, clk, din, re, we, dout);
    end

endmodule
