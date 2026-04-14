`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [23:0] address;
    reg clk;
    reg [7:0] data_in;
    reg enable_RW;
    reg read;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clk(clk),
        .data_in(data_in),
        .enable_RW(enable_RW),
        .read(read),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            address = 24'b0;
            data_in = 8'b0;
            enable_RW = 0;
            read = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read at Address 0");
            reset_dut();


            address = 24'h000000;
            data_in = 8'hA5;
            enable_RW = 1;
            read = 0;
            @(posedge clk);


            enable_RW = 1;
            read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Verify lower 2 bits are ignored (Address Masking)");
            reset_dut();


            address = 24'h000004;
            data_in = 8'h5A;
            enable_RW = 1;
            read = 0;
            @(posedge clk);


            address = 24'h000007;
            enable_RW = 1;
            read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h5A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Overwriting data");
            reset_dut();


            address = 24'h000010;
            data_in = 8'h11;
            enable_RW = 1;
            read = 0;
            @(posedge clk);


            data_in = 8'h22;
            @(posedge clk);


            read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h22);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: enable_RW low should prevent Write");
            reset_dut();


            address = 24'h000020;
            data_in = 8'hCC;
            enable_RW = 1;
            read = 0;
            @(posedge clk);


            enable_RW = 0;
            data_in = 8'hDD;
            @(posedge clk);


            enable_RW = 1;
            read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hCC);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary Check - Maximum Address");
            reset_dut();



            address = 24'hFFFFFC;
            data_in = 8'hEE;
            enable_RW = 1;
            read = 0;
            @(posedge clk);


            address = 24'hFFFFFF;
            read = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'hEE);
        end
        endtask

    task testcase006;

        reg [7:0] val1, val2;
        begin
            $display("Testcase 006: Sequential multi-address access");
            reset_dut();
            val1 = 8'h12;
            val2 = 8'h34;


            address = 24'h000100; data_in = val1; enable_RW = 1; read = 0;
            @(posedge clk);

            address = 24'h000200; data_in = val2;
            @(posedge clk);


            address = 24'h000100; read = 1;
            @(posedge clk);
            #1;
            if (data_out !== val1) $display("Subtest A failed");


            address = 24'h000200;
            @(posedge clk);
            #1;

            #1;


            check_outputs(val2);
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
        $dumpvars(0,address, clk, data_in, enable_RW, read, data_out);
    end

endmodule
