`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [23:0] data_in;
    reg [9:0] rd_address;
    reg [9:0] wr_address;
    reg wr_en;
    wire [23:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_in(data_in),
        .rd_address(rd_address),
        .wr_address(wr_address),
        .wr_en(wr_en),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            wr_en = 0;
            data_in = 0;
            wr_address = 0;
            rd_address = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Basic Write and Read");
            reset_dut();

            wr_en = 1;
            wr_address = 10'h001;
            data_in = 24'hABCDEF;
            @(posedge clock);
            #1;
            wr_en = 0;


            rd_address = 10'h001;
            @(posedge clock);
            #1;
            #1;

            check_outputs(24'hABCDEF);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Max Address Storage (0x3FF)");
            reset_dut();

            wr_en = 1;
            wr_address = 10'h3FF;
            data_in = 24'hFFFFFF;
            @(posedge clock);
            #1;
            wr_en = 0;


            rd_address = 10'h3FF;
            @(posedge clock);
            #1;
            #1;

            check_outputs(24'hFFFFFF);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Write Enable Verification");
            reset_dut();

            wr_en = 1;
            wr_address = 10'h010;
            data_in = 24'h112233;
            @(posedge clock);
            #1;


            wr_en = 0;
            wr_address = 10'h010;
            data_in = 24'h445566;
            @(posedge clock);
            #1;


            rd_address = 10'h010;
            @(posedge clock);
            #1;
            #1;

            check_outputs(24'h112233);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Simultaneous Read and Write (Different Addresses)");
            reset_dut();

            wr_en = 1;
            wr_address = 10'h050;
            data_in = 24'hAAAAAA;
            @(posedge clock);
            #1;


            wr_en = 1;
            wr_address = 10'h060;
            data_in = 24'hBBBBBB;
            rd_address = 10'h050;
            @(posedge clock);
            #1;


            #1;



            check_outputs(24'hAAAAAA);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Overwriting and verifying data integrity");
            reset_dut();

            wr_en = 1; wr_address = 10'h100; data_in = 24'h555555;
            @(posedge clock);
            #1;

            wr_en = 1; wr_address = 10'h100; data_in = 24'h999999;
            @(posedge clock);
            #1;
            wr_en = 0;
            rd_address = 10'h100;
            @(posedge clock);
            #1;
            #1;

            check_outputs(24'h999999);
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
        input [23:0] expected_q;
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
        $dumpvars(0,clock, data_in, rd_address, wr_address, wr_en, q);
    end

endmodule
