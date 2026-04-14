`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] byteena_a;
    reg clock;
    reg [63:0] data;
    reg [7:0] rdaddress;
    reg [7:0] wraddress;
    reg wren;
    wire [63:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .byteena_a(byteena_a),
        .clock(clock),
        .data(data),
        .rdaddress(rdaddress),
        .wraddress(wraddress),
        .wren(wren),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            byteena_a = 8'h00;
            data = 64'h0;
            rdaddress = 8'h0;
            wraddress = 8'h0;
            wren = 0;
            @(posedge clock);
            #2;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            wren = 1;
            wraddress = 8'h10;
            data = 64'hA5A5A5A55A5A5A5A;
            byteena_a = 8'hFF;
            @(posedge clock);
            #2;
            wren = 0;
            rdaddress = 8'h10;
            @(posedge clock);
            #1;

            check_outputs(64'hA5A5A5A55A5A5A5A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            wren = 1;
            wraddress = 8'h20;
            data = 64'hFFFFFFFFFFFFFFFF;
            byteena_a = 8'hAA;
            @(posedge clock);
            #2;
            wren = 0;
            rdaddress = 8'h20;
            @(posedge clock);

            #1;


            check_outputs(64'hFF00FF00FF00FF00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            wren = 1;
            wraddress = 8'h30;
            data = 64'h1234567890ABCDEF;
            byteena_a = 8'hFF;

            #1;
            #1;

            check_outputs(64'bz);
            @(posedge clock);
            #2;
            wren = 0;
            rdaddress = 8'h30;
            @(posedge clock);
            #1;

            check_outputs(64'h1234567890ABCDEF);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            wren = 1;
            wraddress = 8'h01;
            data = 64'h1111111111111111;
            byteena_a = 8'hFF;
            @(posedge clock);
            #2;

            wraddress = 8'h02;
            data = 64'h2222222222222222;
            @(posedge clock);
            #2;
            wren = 0;

            rdaddress = 8'h01;
            @(posedge clock);
            #1;

            check_outputs(64'h1111111111111111);

            rdaddress = 8'h02;
            @(posedge clock);
            #1;

            check_outputs(64'h2222222222222222);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            wren = 1;
            wraddress = 8'h40;
            data = 64'h0000000000000000;
            byteena_a = 8'hFF;
            @(posedge clock);
            #2;

            wraddress = 8'h40;
            data = 64'hDE000000000000AD;
            byteena_a = 8'h81;
            @(posedge clock);
            #2;
            wren = 0;
            rdaddress = 8'h40;
            @(posedge clock);
            #1;

            check_outputs(64'hDE000000000000AD);
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
        input [63:0] expected_q;
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
        $dumpvars(0,byteena_a, clock, data, rdaddress, wraddress, wren, q);
    end

endmodule
