`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [18:0] read_address;
    reg we;
    reg [18:0] write_address;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .read_address(read_address),
        .we(we),
        .write_address(write_address),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            d = 0;
            write_address = 0;
            read_address = 0;

            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Basic Write and Read");
            reset_dut();
            test_num = 1;


            we = 1;
            write_address = 19'd100;
            d = 8'hA5;
            @(posedge clk);
            #1;


            we = 0;
            read_address = 19'd100;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: WE Signal Logic");
            reset_dut();
            test_num = 2;


            we = 1;
            write_address = 19'd500;
            d = 8'h11;
            @(posedge clk);
            #1;


            we = 0;
            write_address = 19'd500;
            d = 8'hEE;
            @(posedge clk);
            #1;


            read_address = 19'd500;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Boundary Check - Addr 0");
            reset_dut();
            test_num = 3;

            we = 1;
            write_address = 19'd0;
            d = 8'hFF;
            @(posedge clk);
            #1;

            we = 0;
            read_address = 19'd0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Boundary Check - Addr 383999");
            reset_dut();
            test_num = 4;

            we = 1;
            write_address = 19'd383999;
            d = 8'h3C;
            @(posedge clk);
            #1;

            we = 0;
            read_address = 19'd383999;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h3C);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Simultaneous Read and Write");
            reset_dut();
            test_num = 5;


            we = 1;
            write_address = 19'd10;
            d = 8'h77;
            @(posedge clk);
            #1;


            we = 1;
            write_address = 19'd20;
            d = 8'h88;
            read_address = 19'd10;
            @(posedge clk);
            #1;


            #1;



            check_outputs(8'h77);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Data Persistence");
            reset_dut();
            test_num = 6;


            we = 1; write_address = 19'd1000; d = 8'hAA;
            @(posedge clk); #1;


            we = 1; write_address = 19'd2000; d = 8'hBB;
            @(posedge clk); #1;


            we = 0;
            read_address = 19'd1000;
            @(posedge clk); #1;

            #1;


            check_outputs(8'hAA);
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
        input [7:0] expected_q;
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
        $dumpvars(0,clk, d, read_address, we, write_address, q);
    end

endmodule
