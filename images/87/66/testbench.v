`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] read_addr;
    reg rst;
    reg [9:0] write_addr;
    reg [63:0] write_data;
    wire [63:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .read_addr(read_addr),
        .rst(rst),
        .write_addr(write_addr),
        .write_data(write_data),
        .read_data(read_data)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            read_addr = 0;
            write_addr = 0;
            write_data = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset Initialization Check", test_num);
            reset_dut();
            read_addr = 10'h1FF;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Simple Write and Read", test_num);
            reset_dut();


            write_addr = 10'd50;
            write_data = 64'hABCDEFFEDCBA0001;
            @(posedge clk);
            #1;
            write_addr = 0;
            write_data = 0;


            repeat(2) @(posedge clk);
            read_addr = 10'd50;


            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'hABCDEFFEDCBA0001);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Simultaneous Read and Write", test_num);
            reset_dut();


            write_addr = 10'd100;
            write_data = 64'h1111222233334444;
            @(posedge clk);
            #1;


            write_addr = 10'd200;
            write_data = 64'h5555666677778888;
            read_addr = 10'd100;

            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(64'h1111222233334444);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Overwrite check", test_num);
            reset_dut();


            write_addr = 10'd777;
            write_data = 64'hAAAAAAAAAAAAAAAA;
            @(posedge clk);
            #1;


            write_addr = 10'd777;
            write_data = 64'hBBBBBBBBBBBBBBBB;
            @(posedge clk);
            #1;
            write_addr = 0;

            repeat(2) @(posedge clk);
            read_addr = 10'd777;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'hBBBBBBBBBBBBBBBB);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Boundary Address Check (1023)", test_num);
            reset_dut();

            write_addr = 10'd1023;
            write_data = 64'hFEDCBA9876543210;
            @(posedge clk);
            #1;

            repeat(2) @(posedge clk);
            read_addr = 10'd1023;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(64'hFEDCBA9876543210);
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
        input [63:0] expected_read_data;
        begin
            if (expected_read_data === (expected_read_data ^ read_data ^ expected_read_data)) begin
                $display("PASS");
                $display("  Outputs: read_data=%h",
                         read_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: read_data=%h",
                         expected_read_data);
                $display("  Got:      read_data=%h",
                         read_data);
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
        $dumpvars(0,clk, read_addr, rst, write_addr, write_data, read_data);
    end

endmodule
