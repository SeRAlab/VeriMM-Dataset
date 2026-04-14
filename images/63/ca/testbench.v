`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] rd_addr;
    reg rd_ena;
    reg [9:0] wr_addr;
    reg [7:0] wr_data;
    reg wr_ena;
    wire [7:0] rd_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .rd_addr(rd_addr),
        .rd_ena(rd_ena),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .wr_ena(wr_ena),
        .rd_data(rd_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        wr_ena = 0;
        rd_ena = 0;
        wr_addr = 0;
        rd_addr = 0;
        wr_data = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        $display("Running testcase001: Basic Write then Read...");
        test_num = 1;
        reset_dut();


        wr_ena = 1;
        wr_addr = 10'h010;
        wr_data = 8'hA5;
        @(posedge clk); #1;
        wr_ena = 0;


        rd_ena = 1;
        rd_addr = 10'h010;
        @(posedge clk); #1;



        @(posedge clk); #1;

        #1;


        check_outputs(8'hA5);
    end
        endtask

    task testcase002;

    begin
        $display("Running testcase002: Simultaneous Write and Read (Different Addr)...");
        test_num = 2;
        reset_dut();


        wr_ena = 1; wr_addr = 10'h020; wr_data = 8'h55;
        @(posedge clk); #1;


        wr_ena = 1; wr_addr = 10'h030; wr_data = 8'hAA;
        rd_ena = 1; rd_addr = 10'h020;
        @(posedge clk); #1;


        wr_ena = 0; rd_ena = 0;
        @(posedge clk); #1;

        #1;


        check_outputs(8'h55);
    end
        endtask

    task testcase003;

    begin
        $display("Running testcase003: Write Enable Check...");
        test_num = 3;
        reset_dut();


        wr_ena = 1; wr_addr = 10'h050; wr_data = 8'hCC;
        @(posedge clk); #1;


        wr_ena = 0; wr_addr = 10'h050; wr_data = 8'hDD;
        @(posedge clk); #1;


        rd_ena = 1; rd_addr = 10'h050;
        @(posedge clk); #1;
        @(posedge clk); #1;


        #1;



        check_outputs(8'hCC);
    end
        endtask

    task testcase004;

    begin
        $display("Running testcase004: Boundary Address and Max Data...");
        test_num = 4;
        reset_dut();


        wr_ena = 1; wr_addr = 10'd1023; wr_data = 8'hFF;
        @(posedge clk); #1;
        wr_ena = 0;


        rd_ena = 1; rd_addr = 10'd1023;
        @(posedge clk); #1;
        @(posedge clk); #1;

        #1;


        check_outputs(8'hFF);
    end
        endtask

    task testcase005;

    begin
        $display("Running testcase005: Data Persistence...");
        test_num = 5;
        reset_dut();


        wr_ena = 1; wr_addr = 10'h123; wr_data = 8'h42;
        @(posedge clk); #1;
        wr_ena = 0;


        repeat(5) @(posedge clk);
        #1;


        rd_ena = 1; rd_addr = 10'h123;
        @(posedge clk); #1;
        @(posedge clk); #1;

        #1;


        check_outputs(8'h42);
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
        input [7:0] expected_rd_data;
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
        $dumpvars(0,clk, rd_addr, rd_ena, wr_addr, wr_data, wr_ena, rd_data);
    end

endmodule
