`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [11:0] address;
    reg clock;
    wire [11:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .clock(clock),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            address = 12'd0;
            @(posedge clock);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            address = 12'd0;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            address = 12'd512;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            address = 12'd1023;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'd0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            address = 12'd1024;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'd1024);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            address = 12'd1500;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'd1500);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            address = 12'd2047;
            @(posedge clock);
            #1;
            #1;

            check_outputs(12'd2047);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            address = 12'd2048;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'h000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            address = 12'd2560;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'd512);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            address = 12'd3071;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'd1023);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;
            address = 12'd3072;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'd3072);
        end
        endtask

    task testcase011;

        begin
            reset_dut();
            test_num = 11;
            address = 12'd3584;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'd3584);
        end
        endtask

    task testcase012;

        begin
            reset_dut();
            test_num = 12;
            address = 12'd4095;
            @(posedge clock);
            #1;

            #1;


            check_outputs(12'd4095);
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
        testcase008();
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        
        
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
        input [11:0] expected_q;
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
        $dumpvars(0,address, clock, q);
    end

endmodule
