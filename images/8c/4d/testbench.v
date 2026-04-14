`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [15:0] data;
    reg [7:0] rdaddress1;
    reg [7:0] rdaddress2;
    reg rden1;
    reg rden2;
    reg [7:0] wraddress1;
    reg [7:0] wraddress2;
    reg wren1;
    reg wren2;
    wire [15:0] q1;
    wire [15:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data(data),
        .rdaddress1(rdaddress1),
        .rdaddress2(rdaddress2),
        .rden1(rden1),
        .rden2(rden2),
        .wraddress1(wraddress1),
        .wraddress2(wraddress2),
        .wren1(wren1),
        .wren2(wren2),
        .q1(q1),
        .q2(q2)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            data = 0;
            rdaddress1 = 0;
            rdaddress2 = 0;
            rden1 = 0;
            rden2 = 0;
            wraddress1 = 0;
            wraddress2 = 0;
            wren1 = 0;
            wren2 = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            data = 16'hABCD;
            wraddress1 = 8'h10;
            wren1 = 1;
            @(posedge clock);
            #1;
            wren1 = 0;

            rdaddress1 = 8'h10;
            rden1 = 1;
            @(posedge clock);
            #1;

            check_outputs(16'hABCD, 16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            data = 16'h1234;
            wraddress2 = 8'h20;
            wren2 = 1;
            @(posedge clock);
            #1;
            wren2 = 0;

            rdaddress2 = 8'h20;
            rden2 = 1;
            @(posedge clock);
            #1;

            check_outputs(16'h0000, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            data = 16'h55AA;
            wraddress1 = 8'h30;
            wraddress2 = 8'h40;
            wren1 = 1;
            wren2 = 1;
            @(posedge clock);
            #1;
            wren1 = 0;
            wren2 = 0;

            rdaddress1 = 8'h30;
            rdaddress2 = 8'h40;
            rden1 = 1;
            rden2 = 1;
            @(posedge clock);
            #1;

            check_outputs(16'h55AA, 16'h55AA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            data = 16'hDEAD;
            wraddress1 = 8'h50;
            wren1 = 1;
            @(posedge clock);
            #1;
            wren1 = 0;

            rdaddress1 = 8'h50;
            rdaddress2 = 8'h50;
            rden1 = 0;
            rden2 = 0;
            @(posedge clock);
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            data = 16'hBEEF;
            wraddress1 = 8'h60;
            wren1 = 1;
            @(posedge clock);
            #1;
            wren1 = 0;

            rdaddress2 = 8'h60;
            rden2 = 1;
            @(posedge clock);
            #1;

            check_outputs(16'h0000, 16'hBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            data = 16'h7777;
            wraddress1 = 8'h70;
            wren1 = 1;
            @(posedge clock);
            #1;
            wren1 = 0;


            data = 16'h8888;
            wraddress2 = 8'h80;
            wren2 = 1;
            rdaddress1 = 8'h70;
            rden1 = 1;
            @(posedge clock);
            #1;
            wren2 = 0;
            rden1 = 0;


            rdaddress2 = 8'h80;
            rden2 = 1;


            @(posedge clock);
            #1;

            check_outputs(16'h0000, 16'h8888);
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
        input [15:0] expected_q1;
        input [15:0] expected_q2;
        begin
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h",
                         q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h",
                         expected_q1, expected_q2);
                $display("  Got:      q1=%h, q2=%h",
                         q1, q2);
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
        $dumpvars(0,clock, data, rdaddress1, rdaddress2, rden1, rden2, wraddress1, wraddress2, wren1, wren2, q1, q2);
    end

endmodule
