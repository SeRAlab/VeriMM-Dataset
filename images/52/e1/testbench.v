`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [11:0] io_bus_addr;
    reg [31:0] io_bus_data_in;
    reg io_bus_enable;
    reg io_bus_write;
    reg [11:0] io_core_r_addr;
    reg io_core_r_enable;
    reg [11:0] io_core_rw_addr;
    reg [31:0] io_core_rw_data_in;
    reg io_core_rw_enable;
    reg io_core_rw_write;
    wire [31:0] io_bus_data_out;
    wire io_bus_ready;
    wire [31:0] io_core_r_data_out;
    wire [31:0] io_core_rw_data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .io_bus_addr(io_bus_addr),
        .io_bus_data_in(io_bus_data_in),
        .io_bus_enable(io_bus_enable),
        .io_bus_write(io_bus_write),
        .io_core_r_addr(io_core_r_addr),
        .io_core_r_enable(io_core_r_enable),
        .io_core_rw_addr(io_core_rw_addr),
        .io_core_rw_data_in(io_core_rw_data_in),
        .io_core_rw_enable(io_core_rw_enable),
        .io_core_rw_write(io_core_rw_write),
        .io_bus_data_out(io_bus_data_out),
        .io_bus_ready(io_bus_ready),
        .io_core_r_data_out(io_core_r_data_out),
        .io_core_rw_data_out(io_core_rw_data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            io_bus_addr = 0;
            io_bus_data_in = 0;
            io_bus_enable = 0;
            io_bus_write = 0;
            io_core_r_addr = 0;
            io_core_r_enable = 0;
            io_core_rw_addr = 0;
            io_core_rw_data_in = 0;
            io_core_rw_enable = 0;
            io_core_rw_write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            io_core_rw_addr = 12'h100;
            io_core_rw_data_in = 32'hA5A5A5A5;
            io_core_rw_enable = 1;
            io_core_rw_write = 1;
            @(posedge clk);
            #1;


            io_core_rw_write = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Core RW Port Write/Read", test_num);
            #1;

            check_outputs(32'h0, 1'b0, 32'h0, 32'hA5A5A5A5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            io_core_rw_addr = 12'hABC;
            io_core_rw_data_in = 32'h12345678;
            io_core_rw_enable = 1;
            io_core_rw_write = 1;
            @(posedge clk);
            #1;


            io_core_rw_enable = 0;
            io_core_r_addr = 12'hABC;
            io_core_r_enable = 1;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Core RW Write and Core R Read", test_num);

            #1;


            check_outputs(32'h0, 1'b0, 32'h12345678, 32'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            io_bus_addr = 12'h00F;
            io_bus_data_in = 32'hDEADBEEF;
            io_bus_enable = 1;
            io_bus_write = 1;
            @(posedge clk);
            #1;


            io_bus_write = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Bus Interface Write/Read", test_num);
            #1;

            check_outputs(32'hDEADBEEF, 1'b0, 32'h0, 32'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            io_core_rw_addr = 12'h001;
            io_core_rw_data_in = 32'h11111111;
            io_core_rw_enable = 1;
            io_core_rw_write = 1;
            @(posedge clk);
            #1;





            io_core_rw_addr = 12'h002;
            io_core_rw_data_in = 32'h22222222;
            io_core_rw_write = 1;

            io_core_r_addr = 12'h001;
            io_core_r_enable = 1;

            io_bus_addr = 12'h001;
            io_bus_enable = 1;
            io_bus_write = 0;

            @(posedge clk);
            #1;

            $display("Testcase %0d: Simultaneous Read/Write Access", test_num);
            #1;

            check_outputs(32'h11111111, 1'b0, 32'h11111111, 32'h22222222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();


            io_core_rw_addr = 12'h555;
            io_core_rw_data_in = 32'hFFFFFFFF;
            io_core_rw_enable = 0;
            io_core_rw_write = 1;
            @(posedge clk);
            #1;


            io_core_rw_enable = 1;
            io_core_rw_write = 0;
            @(posedge clk);
            #1;

            $display("Testcase %0d: Enable Signal Logic Check", test_num);

            if (io_core_rw_data_out !== 32'hFFFFFFFF) begin

                 #1;


                 check_outputs(32'h0, 1'b0, 32'h0, io_core_rw_data_out);
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: Data written while core_rw_enable was low");
            end
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
        input [31:0] expected_io_bus_data_out;
        input expected_io_bus_ready;
        input [31:0] expected_io_core_r_data_out;
        input [31:0] expected_io_core_rw_data_out;
        begin
            if (expected_io_bus_data_out === (expected_io_bus_data_out ^ io_bus_data_out ^ expected_io_bus_data_out) &&
                expected_io_bus_ready === (expected_io_bus_ready ^ io_bus_ready ^ expected_io_bus_ready) &&
                expected_io_core_r_data_out === (expected_io_core_r_data_out ^ io_core_r_data_out ^ expected_io_core_r_data_out) &&
                expected_io_core_rw_data_out === (expected_io_core_rw_data_out ^ io_core_rw_data_out ^ expected_io_core_rw_data_out)) begin
                $display("PASS");
                $display("  Outputs: io_bus_data_out=%h, io_bus_ready=%b, io_core_r_data_out=%h, io_core_rw_data_out=%h",
                         io_bus_data_out, io_bus_ready, io_core_r_data_out, io_core_rw_data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_bus_data_out=%h, io_bus_ready=%b, io_core_r_data_out=%h, io_core_rw_data_out=%h",
                         expected_io_bus_data_out, expected_io_bus_ready, expected_io_core_r_data_out, expected_io_core_rw_data_out);
                $display("  Got:      io_bus_data_out=%h, io_bus_ready=%b, io_core_r_data_out=%h, io_core_rw_data_out=%h",
                         io_bus_data_out, io_bus_ready, io_core_r_data_out, io_core_rw_data_out);
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
        $dumpvars(0,clk, io_bus_addr, io_bus_data_in, io_bus_enable, io_bus_write, io_core_r_addr, io_core_r_enable, io_core_rw_addr, io_core_rw_data_in, io_core_rw_enable, io_core_rw_write, io_bus_data_out, io_bus_ready, io_core_r_data_out, io_core_rw_data_out);
    end

endmodule
