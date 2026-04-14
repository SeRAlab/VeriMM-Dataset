`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg clk;
    reg [7:0] din1;
    reg [7:0] din2;
    reg write_en1;
    reg write_en2;
    wire [7:0] dout1;
    wire [7:0] dout2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr1(addr1),
        .addr2(addr2),
        .clk(clk),
        .din1(din1),
        .din2(din2),
        .write_en1(write_en1),
        .write_en2(write_en2),
        .dout1(dout1),
        .dout2(dout2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            write_en1 = 0;
            write_en2 = 0;
            addr1 = 0;
            addr2 = 0;
            din1 = 0;
            din2 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            $display("Running Testcase 001: Basic Write/Read Port 1");

            write_en1 = 1; addr1 = 8'h10; din1 = 8'hA5;
            @(posedge clk);
            #1;

            write_en1 = 0; addr1 = 8'h10;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hA5, 8'h00);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            $display("Running Testcase 002: Basic Write/Read Port 2");

            write_en2 = 1; addr2 = 8'h20; din2 = 8'h5A;
            @(posedge clk);
            #1;

            write_en2 = 0; addr2 = 8'h20;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            $display("Running Testcase 003: Simultaneous Write Port 1 and Port 2");

            write_en1 = 1; addr1 = 8'h01; din1 = 8'h11;
            write_en2 = 1; addr2 = 8'h02; din2 = 8'h22;
            @(posedge clk);
            #1;

            write_en1 = 0; addr1 = 8'h01;
            write_en2 = 0; addr2 = 8'h02;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            $display("Running Testcase 004: Overwrite Data Port 1");

            write_en1 = 1; addr1 = 8'hFF; din1 = 8'hAA;
            @(posedge clk);
            #1;

            din1 = 8'hBB;
            @(posedge clk);
            #1;
            write_en1 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'hBB, 8'h00);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            $display("Running Testcase 005: Write Enable Off Check");

            write_en1 = 0; addr1 = 8'h05; din1 = 8'h77;
            @(posedge clk);
            #1;

            addr1 = 8'h05;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h00, 8'h00);
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
        input [7:0] expected_dout1;
        input [7:0] expected_dout2;
        begin
            if (expected_dout1 === (expected_dout1 ^ dout1 ^ expected_dout1) &&
                expected_dout2 === (expected_dout2 ^ dout2 ^ expected_dout2)) begin
                $display("PASS");
                $display("  Outputs: dout1=%h, dout2=%h",
                         dout1, dout2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout1=%h, dout2=%h",
                         expected_dout1, expected_dout2);
                $display("  Got:      dout1=%h, dout2=%h",
                         dout1, dout2);
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
        $dumpvars(0,addr1, addr2, clk, din1, din2, write_en1, write_en2, dout1, dout2);
    end

endmodule
