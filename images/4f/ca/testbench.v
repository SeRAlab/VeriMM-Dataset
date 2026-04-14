`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg write_en;
    wire [7:0] data_out;

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
            test_num = 1;
            reset_dut();

            addr = 4'h4;
            data_in = 8'hAA;
            write_en = 1;
            @(posedge clk);
            #1;

            write_en = 0;
            addr = 4'h4;
            @(posedge clk);
            #1;
            $display("Testcase 001: Basic Write/Read Address 4");
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            addr = 4'h0;
            data_in = 8'h11;
            write_en = 1;
            @(posedge clk);
            #1;

            addr = 4'hF;
            data_in = 8'hFF;
            write_en = 1;
            @(posedge clk);
            #1;

            write_en = 0;
            addr = 4'hF;
            @(posedge clk);
            #1;
            $display("Testcase 002: Boundary Address 15 Check");
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            addr = 4'h7;
            data_in = 8'h33;
            write_en = 1;
            @(posedge clk);
            #1;

            addr = 4'h7;
            data_in = 8'hCC;
            write_en = 1;
            @(posedge clk);
            #1;

            write_en = 0;
            @(posedge clk);
            #1;
            $display("Testcase 003: Overwrite Address 7");
            #1;

            check_outputs(8'hCC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            addr = 4'h2;
            data_in = 8'h55;
            write_en = 1;
            @(posedge clk);
            #1;

            addr = 4'h2;
            data_in = 8'h99;
            write_en = 0;
            @(posedge clk);
            #1;

            addr = 4'h2;
            @(posedge clk);
            #1;
            $display("Testcase 004: Write Enable Low Verification");
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            addr = 4'hA;
            data_in = 8'hA1;
            write_en = 1;
            @(posedge clk);
            #1;

            addr = 4'hB;
            data_in = 8'hB2;
            write_en = 1;
            @(posedge clk);
            #1;

            addr = 4'hA;
            write_en = 0;
            @(posedge clk);
            #1;
            $display("Testcase 005: Multi-Address Independence (Addr A)");
            #1;

            check_outputs(8'hA1);
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
        input [7:0] expected_data_out;
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
