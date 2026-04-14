`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] io_bus_addr;
    reg io_bus_byte_write_0;
    reg io_bus_byte_write_1;
    reg io_bus_byte_write_2;
    reg io_bus_byte_write_3;
    reg [31:0] io_bus_data_in;
    reg io_bus_enable;
    reg [11:0] io_core_addr;
    reg io_core_byte_write_0;
    reg io_core_byte_write_1;
    reg io_core_byte_write_2;
    reg io_core_byte_write_3;
    reg [31:0] io_core_data_in;
    reg io_core_enable;
    wire [31:0] io_bus_data_out;
    wire [31:0] io_core_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_bus_addr(io_bus_addr),
        .io_bus_byte_write_0(io_bus_byte_write_0),
        .io_bus_byte_write_1(io_bus_byte_write_1),
        .io_bus_byte_write_2(io_bus_byte_write_2),
        .io_bus_byte_write_3(io_bus_byte_write_3),
        .io_bus_data_in(io_bus_data_in),
        .io_bus_enable(io_bus_enable),
        .io_core_addr(io_core_addr),
        .io_core_byte_write_0(io_core_byte_write_0),
        .io_core_byte_write_1(io_core_byte_write_1),
        .io_core_byte_write_2(io_core_byte_write_2),
        .io_core_byte_write_3(io_core_byte_write_3),
        .io_core_data_in(io_core_data_in),
        .io_core_enable(io_core_enable),
        .io_bus_data_out(io_bus_data_out),
        .io_core_data_out(io_core_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            io_core_addr = 0;
            io_core_enable = 0;
            io_core_data_in = 0;
            io_core_byte_write_0 = 0;
            io_core_byte_write_1 = 0;
            io_core_byte_write_2 = 0;
            io_core_byte_write_3 = 0;
            io_bus_addr = 0;
            io_bus_enable = 0;
            io_bus_data_in = 0;
            io_bus_byte_write_0 = 0;
            io_bus_byte_write_1 = 0;
            io_bus_byte_write_2 = 0;
            io_bus_byte_write_3 = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Core Write and Read...");
            reset_dut();

            io_core_addr = 12'h100;
            io_core_enable = 1;
            io_core_data_in = 32'hA5A5A5A5;
            io_core_byte_write_0 = 1;
            io_core_byte_write_1 = 1;
            io_core_byte_write_2 = 1;
            io_core_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_core_byte_write_0 = 0; io_core_byte_write_1 = 0;
            io_core_byte_write_2 = 0; io_core_byte_write_3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Bus Write and Read...");
            reset_dut();

            io_bus_addr = 12'h200;
            io_bus_enable = 1;
            io_bus_data_in = 32'h5A5A5A5A;
            io_bus_byte_write_0 = 1;
            io_bus_byte_write_1 = 1;
            io_bus_byte_write_2 = 1;
            io_bus_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_bus_byte_write_0 = 0; io_bus_byte_write_1 = 0;
            io_bus_byte_write_2 = 0; io_bus_byte_write_3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h5A5A5A5A, 32'h0);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Core Write, Bus Read...");
            reset_dut();

            io_core_addr = 12'h300;
            io_core_enable = 1;
            io_core_data_in = 32'h12345678;
            io_core_byte_write_0 = 1; io_core_byte_write_1 = 1;
            io_core_byte_write_2 = 1; io_core_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_core_enable = 0;
            io_bus_addr = 12'h300;
            io_bus_enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h12345678, 32'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Core Byte-masking...");
            reset_dut();

            io_core_addr = 12'h400;
            io_core_enable = 1;
            io_core_data_in = 32'hFFFFFFFF;
            io_core_byte_write_0 = 1; io_core_byte_write_1 = 1;
            io_core_byte_write_2 = 1; io_core_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_core_data_in = 32'h00000000;
            io_core_byte_write_1 = 0; io_core_byte_write_3 = 0;
            @(posedge clk);
            #1;

            io_core_byte_write_0 = 0; io_core_byte_write_2 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h0, 32'hFF00FF00);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Bus Byte-masking...");
            reset_dut();

            io_bus_addr = 12'h500;
            io_bus_enable = 1;
            io_bus_data_in = 32'hAAAAAAAA;
            io_bus_byte_write_0 = 1; io_bus_byte_write_1 = 1;
            io_bus_byte_write_2 = 1; io_bus_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_bus_data_in = 32'h55555555;
            io_bus_byte_write_0 = 0; io_bus_byte_write_2 = 0;
            @(posedge clk);
            #1;

            io_bus_byte_write_1 = 0; io_bus_byte_write_3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'h55AA55AA, 32'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous Port Access...");
            reset_dut();

            io_core_addr = 12'h600; io_core_enable = 1; io_core_data_in = 32'hC0DE1111;
            io_core_byte_write_0 = 1; io_core_byte_write_1 = 1; io_core_byte_write_2 = 1; io_core_byte_write_3 = 1;
            io_bus_addr = 12'h700; io_bus_enable = 1; io_bus_data_in = 32'hB0552222;
            io_bus_byte_write_0 = 1; io_bus_byte_write_1 = 1; io_bus_byte_write_2 = 1; io_bus_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_core_byte_write_0 = 0; io_core_byte_write_1 = 0; io_core_byte_write_2 = 0; io_core_byte_write_3 = 0;
            io_bus_byte_write_0 = 0; io_bus_byte_write_1 = 0; io_bus_byte_write_2 = 0; io_bus_byte_write_3 = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(32'hB0552222, 32'hC0DE1111);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Enable Signal Test...");
            reset_dut();

            io_core_addr = 12'h800;
            io_core_enable = 0;
            io_core_data_in = 32'hDEADBEEF;
            io_core_byte_write_0 = 1; io_core_byte_write_1 = 1;
            io_core_byte_write_2 = 1; io_core_byte_write_3 = 1;
            @(posedge clk);
            #1;

            io_core_enable = 1;
            io_core_byte_write_0 = 0; io_core_byte_write_1 = 0;
            io_core_byte_write_2 = 0; io_core_byte_write_3 = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(32'h0, 32'h0);
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
        testcase007();
        
        
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
        input [31:0] expected_io_bus_data_out;
        input [31:0] expected_io_core_data_out;
        begin
            if (expected_io_bus_data_out === (expected_io_bus_data_out ^ io_bus_data_out ^ expected_io_bus_data_out) &&
                expected_io_core_data_out === (expected_io_core_data_out ^ io_core_data_out ^ expected_io_core_data_out)) begin
                $display("PASS");
                $display("  Outputs: io_bus_data_out=%h, io_core_data_out=%h",
                         io_bus_data_out, io_core_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_bus_data_out=%h, io_core_data_out=%h",
                         expected_io_bus_data_out, expected_io_core_data_out);
                $display("  Got:      io_bus_data_out=%h, io_core_data_out=%h",
                         io_bus_data_out, io_core_data_out);
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
        $dumpvars(0,clk, io_bus_addr, io_bus_byte_write_0, io_bus_byte_write_1, io_bus_byte_write_2, io_bus_byte_write_3, io_bus_data_in, io_bus_enable, io_core_addr, io_core_byte_write_0, io_core_byte_write_1, io_core_byte_write_2, io_core_byte_write_3, io_core_data_in, io_core_enable, io_bus_data_out, io_core_data_out);
    end

endmodule
