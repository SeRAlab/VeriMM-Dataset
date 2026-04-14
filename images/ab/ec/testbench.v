`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] rd_addr;
    reg [3:0] wr_addr;
    reg [3:0] wr_data;
    reg wr_enable;
    wire [3:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_addr(rd_addr),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_enable(wr_enable),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            wr_addr = 0;
            wr_data = 0;
            wr_enable = 0;
            rd_addr = 0;
            @(posedge clk);
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read...");
            reset_dut();


            wr_enable = 1;
            wr_addr = 4'h5;
            wr_data = 4'hA;
            @(posedge clk);
            #2;


            wr_enable = 0;
            rd_addr = 4'h5;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verify Write Enable functionality...");
            reset_dut();


            wr_enable = 1;
            wr_addr = 4'h3;
            wr_data = 4'h7;
            @(posedge clk);
            #2;


            wr_enable = 0;
            wr_addr = 4'h3;
            wr_data = 4'hF;
            @(posedge clk);
            #2;


            rd_addr = 4'h3;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h7);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Simultaneous Write and Read (different addrs)...");
            reset_dut();


            wr_enable = 1;
            wr_addr = 4'h0;
            wr_data = 4'h1;
            @(posedge clk);
            #2;


            wr_enable = 1;
            wr_addr = 4'hF;
            wr_data = 4'hE;
            rd_addr = 4'h0;
            @(posedge clk);
            #2;


            #1;



            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Overwriting data at the same address...");
            reset_dut();


            wr_enable = 1;
            wr_addr = 4'h8;
            wr_data = 4'h1;
            @(posedge clk);
            #2;


            wr_data = 4'h2;
            @(posedge clk);
            #2;


            wr_enable = 0;
            rd_addr = 4'h8;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h2);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary address 15 check...");
            reset_dut();

            wr_enable = 1;
            wr_addr = 4'hF;
            wr_data = 4'hB;
            @(posedge clk);
            #2;

            wr_enable = 0;
            rd_addr = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hB);
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
        input [3:0] expected_rd_data;
        begin
            if (expected_rd_data === (expected_rd_data ^ rd_data ^ expected_rd_data)) begin
                $display("PASS");
                $display("  Outputs: rd_data=%h",
                         rd_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: rd_data=%h",
                         expected_rd_data);
                $display("  Got:      rd_data=%h",
                         rd_data);
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
        $dumpvars(0,clk, rd_addr, wr_addr, wr_data, wr_enable, rd_data);
    end

endmodule
