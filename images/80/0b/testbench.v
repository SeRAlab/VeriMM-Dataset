`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr1;
    reg [7:0] addr2;
    reg clk;
    reg [7:0] din1;
    reg [7:0] din2;
    reg we1;
    reg we2;
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
        .we1(we1),
        .we2(we2),
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
            we1 = 0;
            we2 = 0;
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
            $display("Running Testcase 001: Port 1 Basic Write/Read");
            test_num = 1;
            reset_dut();


            addr1 = 8'h10;
            din1 = 8'h55;
            we1 = 1;
            @(posedge clk);
            #1;


            we1 = 0;
            addr1 = 8'h10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h55, dout2);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Port 2 Basic Write/Read");
            test_num = 2;
            reset_dut();


            addr2 = 8'h20;
            din2 = 8'hAA;
            we2 = 1;
            @(posedge clk);
            #1;


            we2 = 0;
            addr2 = 8'h20;
            @(posedge clk);
            #1;


            #1;



            check_outputs(dout1, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Simultaneous Writes to Different Addresses");
            test_num = 3;
            reset_dut();


            addr1 = 8'h01; din1 = 8'h11; we1 = 1;
            addr2 = 8'h02; din2 = 8'h22; we2 = 1;
            @(posedge clk);
            #1;


            we1 = 0; we2 = 0;
            addr1 = 8'h01;
            addr2 = 8'h02;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11, 8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Cross-Port Access (P1 Write, P2 Read same addr)");
            test_num = 4;
            reset_dut();


            addr1 = 8'h30; din1 = 8'hBC; we1 = 1;
            @(posedge clk);
            #1;
            we1 = 0;


            addr2 = 8'h30;
            addr1 = 8'h00;
            @(posedge clk);
            #1;

            #1;


            check_outputs(dout1, 8'hBC);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Independence Check");
            test_num = 5;
            reset_dut();


            addr1 = 8'h40; din1 = 8'h99; we1 = 1;
            @(posedge clk);
            #1;


            we1 = 0;
            addr1 = 8'h40;
            addr2 = 8'h50; din2 = 8'hEE; we2 = 1;
            @(posedge clk);
            #1;


            we2 = 0;
            addr2 = 8'h50;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h99, 8'hEE);
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
        $dumpvars(0,addr1, addr2, clk, din1, din2, we1, we2, dout1, dout2);
    end

endmodule
