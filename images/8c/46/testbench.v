`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] io_r_addr;
    reg [3:0] io_w_addr;
    reg [31:0] io_w_data;
    reg io_w_en;
    wire [31:0] io_output_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .io_r_addr(io_r_addr),
        .io_w_addr(io_w_addr),
        .io_w_data(io_w_data),
        .io_w_en(io_w_en),
        .io_output_data(io_output_data)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            io_w_en = 0;
            io_w_addr = 0;
            io_w_data = 0;
            io_r_addr = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read back");
            reset_dut();


            io_w_addr = 4'h0;
            io_w_data = 32'hDEADBEEF;
            io_w_en = 1;
            @(posedge clock);
            #1;
            io_w_en = 0;


            io_r_addr = 4'h0;
            #1;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multiple address writes");
            reset_dut();


            io_w_addr = 4'h5;
            io_w_data = 32'h12345678;
            io_w_en = 1;
            @(posedge clock);
            #1;


            io_w_addr = 4'hA;
            io_w_data = 32'h87654321;
            io_w_en = 1;
            @(posedge clock);
            #1;
            io_w_en = 0;


            io_r_addr = 4'h5;
            #1;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Write Enable (Disable) test");
            reset_dut();


            io_w_addr = 4'h2;
            io_w_data = 32'hAAAA_AAAA;
            io_w_en = 1;
            @(posedge clock);
            #1;


            io_w_addr = 4'h2;
            io_w_data = 32'hBBBB_BBBB;
            io_w_en = 0;
            @(posedge clock);
            #1;


            io_r_addr = 4'h2;
            #1;
            #1;

            check_outputs(32'hAAAA_AAAA);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary address (Address 15) test");
            reset_dut();


            io_w_addr = 4'hF;
            io_w_data = 32'hFFFF_FFFF;
            io_w_en = 1;
            @(posedge clock);
            #1;
            io_w_en = 0;


            io_r_addr = 4'hF;
            #1;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting existing data");
            reset_dut();


            io_w_addr = 4'h7;
            io_w_data = 32'h0000_1111;
            io_w_en = 1;
            @(posedge clock);
            #1;


            io_w_addr = 4'h7;
            io_w_data = 32'h2222_3333;
            io_w_en = 1;
            @(posedge clock);
            #1;
            io_w_en = 0;


            io_r_addr = 4'h7;
            #1;
            #1;

            check_outputs(32'h2222_3333);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Simultaneous Read and Write");
            reset_dut();


            io_w_addr = 4'h1;
            io_w_data = 32'hCAFE_BABE;
            io_w_en = 1;
            @(posedge clock);
            #1;


            io_r_addr = 4'h1;
            io_w_addr = 4'h2;
            io_w_data = 32'hBEEF_FEED;
            io_w_en = 1;

            #2;
            #1;

            check_outputs(32'hCAFE_BABE);

            @(posedge clock);
            #1;
            io_w_en = 0;
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
        input [31:0] expected_io_output_data;
        begin
            if (expected_io_output_data === (expected_io_output_data ^ io_output_data ^ expected_io_output_data)) begin
                $display("PASS");
                $display("  Outputs: io_output_data=%h",
                         io_output_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: io_output_data=%h",
                         expected_io_output_data);
                $display("  Got:      io_output_data=%h",
                         io_output_data);
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
        $dumpvars(0,clock, io_r_addr, io_w_addr, io_w_data, io_w_en, io_output_data);
    end

endmodule
