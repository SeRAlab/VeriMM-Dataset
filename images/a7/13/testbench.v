`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg re;
    reg we;
    reg [7:0] write_data;
    wire [7:0] read_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .re(re),
        .we(we),
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
            we = 0;
            re = 0;
            addr = 0;
            write_data = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;


            addr = 4'h5;
            write_data = 8'hA5;
            we = 1;
            re = 0;
            @(posedge clk);
            #1;


            we = 0;
            re = 1;
            @(posedge clk);
            #1;

            $display("Testcase 001: Basic Write and Read");
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;


            addr = 4'h0;
            write_data = 8'h11;
            we = 1;
            @(posedge clk);
            #1;


            addr = 4'hF;
            write_data = 8'hFF;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            re = 1;
            addr = 4'h0;
            @(posedge clk);
            #1;



            addr = 4'hF;
            @(posedge clk);
            #1;

            $display("Testcase 002: Multiple Register Persistence");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;


            addr = 4'h8;
            write_data = 8'hCC;
            we = 1;
            @(posedge clk);
            #1;


            write_data = 8'hDD;
            we = 0;
            @(posedge clk);
            #1;


            re = 1;
            @(posedge clk);
            #1;

            $display("Testcase 003: Write Enable (we) functionality");
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;


            addr = 4'h2;
            write_data = 8'h77;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            re = 1;
            @(posedge clk);
            #1;


            addr = 4'h3;
            re = 0;
            @(posedge clk);
            #1;

            $display("Testcase 004: Read Enable (re) functionality");

            #1;


            check_outputs(8'h77);
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
        input [7:0] expected_read_data;
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
        $dumpvars(0,addr, clk, re, we, write_data, read_data);
    end

endmodule
