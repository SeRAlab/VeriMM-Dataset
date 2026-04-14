`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] addr;
    reg clk;
    reg [31:0] data_in;
    reg write_en;
    wire [31:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            write_en = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Lower BRAM Access");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            addr = 16'h1234;
            data_in = 32'hDEADBEEF;
            write_en = 1;

            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Upper BRAM Access");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            addr = 16'h8001;
            data_in = 32'hCAFEBABE;
            write_en = 1;

            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Lower BRAM Boundary (32767)");
            reset_dut();
            test_num = test_num + 1;

            @(posedge clk);
            addr = 16'h7FFF;
            data_in = 32'hAAAA5555;
            write_en = 1;

            @(posedge clk);
            write_en = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hAAAA5555);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Upper BRAM Boundary (32768)");
            reset_dut();
            test_num = test_num + 1;

            @(posedge clk);
            addr = 16'h8000;
            data_in = 32'h5555AAAA;
            write_en = 1;

            @(posedge clk);
            write_en = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5555AAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Data Persistence and Overwrite");
            reset_dut();
            test_num = test_num + 1;


            @(posedge clk);
            addr = 16'hA000;
            data_in = 32'h11111111;
            write_en = 1;


            @(posedge clk);
            data_in = 32'h22222222;

            @(posedge clk);
            write_en = 0;


            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h22222222);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Max Address Range (65535)");
            reset_dut();
            test_num = test_num + 1;

            @(posedge clk);
            addr = 16'hFFFF;
            data_in = 32'hFFFFFFFF;
            write_en = 1;

            @(posedge clk);
            write_en = 0;

            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,addr, clk, data_in, write_en, data_out);
    end

endmodule
