`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg flush;
    reg [2:0] read_adr_1;
    reg [2:0] read_adr_2;
    reg [2:0] write_adr;
    reg [15:0] write_data;
    reg write_en;
    wire [15:0] data_out_1;
    wire [15:0] data_out_2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .flush(flush),
        .read_adr_1(read_adr_1),
        .read_adr_2(read_adr_2),
        .write_adr(write_adr),
        .write_data(write_data),
        .write_en(write_en),
        .data_out_1(data_out_1),
        .data_out_2(data_out_2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            flush = 0;
            read_adr_1 = 0;
            read_adr_2 = 0;
            write_adr = 0;
            write_data = 0;
            write_en = 0;
            @(negedge clock);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Single Read");
            reset_dut();


            write_adr = 3'd3;
            write_data = 16'hABCD;
            write_en = 1;
            @(negedge clock);
            write_en = 0;


            read_adr_1 = 3'd3;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Dual Read");
            reset_dut();


            write_adr = 3'd1;
            write_data = 16'h1111;
            write_en = 1;
            @(negedge clock);


            write_adr = 3'd5;
            write_data = 16'h5555;
            write_en = 1;
            @(negedge clock);
            write_en = 0;


            read_adr_1 = 3'd1;
            read_adr_2 = 3'd5;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h1111, 16'h5555);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Flush Feature");
            reset_dut();


            write_adr = 3'd2;
            write_data = 16'h2222;
            write_en = 1;
            @(negedge clock);
            write_en = 0;


            read_adr_1 = 3'd2;
            read_adr_2 = 3'd2;
            flush = 1;
            @(posedge clock);
            #1;


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Write Enable Gate check");
            reset_dut();


            write_adr = 3'd4;
            write_data = 16'hFFFF;
            write_en = 0;
            @(negedge clock);


            read_adr_1 = 3'd4;
            @(posedge clock);
            #1;


            #1;



            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwrite check");
            reset_dut();


            write_adr = 3'd7;
            write_data = 16'hAAAA;
            write_en = 1;
            @(negedge clock);


            write_data = 16'h5555;
            @(negedge clock);
            write_en = 0;


            read_adr_1 = 3'd7;
            @(posedge clock);
            #1;

            #1;


            check_outputs(16'h5555, 16'h0000);
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
        input [15:0] expected_data_out_1;
        input [15:0] expected_data_out_2;
        begin
            if (expected_data_out_1 === (expected_data_out_1 ^ data_out_1 ^ expected_data_out_1) &&
                expected_data_out_2 === (expected_data_out_2 ^ data_out_2 ^ expected_data_out_2)) begin
                $display("PASS");
                $display("  Outputs: data_out_1=%h, data_out_2=%h",
                         data_out_1, data_out_2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out_1=%h, data_out_2=%h",
                         expected_data_out_1, expected_data_out_2);
                $display("  Got:      data_out_1=%h, data_out_2=%h",
                         data_out_1, data_out_2);
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
        $dumpvars(0,clock, flush, read_adr_1, read_adr_2, write_adr, write_data, write_en, data_out_1, data_out_2);
    end

endmodule
