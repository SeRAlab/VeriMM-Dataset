`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] avs_s0_address;
    reg avs_s0_read;
    reg avs_s0_write;
    reg [127:0] avs_s0_writedata;
    reg clock_clk;
    reg reset_reset;
    wire [127:0] avs_s0_readdata;
    wire avs_s0_waitrequest;
    wire [7:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .avs_s0_address(avs_s0_address),
        .avs_s0_read(avs_s0_read),
        .avs_s0_write(avs_s0_write),
        .avs_s0_writedata(avs_s0_writedata),
        .clock_clk(clock_clk),
        .reset_reset(reset_reset),
        .avs_s0_readdata(avs_s0_readdata),
        .avs_s0_waitrequest(avs_s0_waitrequest),
        .led(led)
    );

    // Clock generation (10ns period)
    initial begin
        clock_clk = 0;
        forever #5 clock_clk = ~clock_clk;
    end

        task reset_dut;

        begin
            reset_reset = 1;
            avs_s0_address = 0;
            avs_s0_read = 0;
            avs_s0_write = 0;
            avs_s0_writedata = 0;
            @(posedge clock_clk);
            #1;
            reset_reset = 0;
            @(posedge clock_clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Power-on Reset Verification");
            reset_dut();


            #1;



            check_outputs(128'h0, 0, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Basic Write Operation (0x5A)");
            reset_dut();


            avs_s0_write = 1;
            avs_s0_writedata = 128'h5A;
            @(posedge clock_clk);
            #1;
            avs_s0_write = 0;


            #1;



            check_outputs(128'h0, 0, 8'h5A);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Read Operation and 128-bit Bus Formatting");
            reset_dut();


            avs_s0_write = 1;
            avs_s0_writedata = 128'hA5;
            @(posedge clock_clk);
            #1;
            avs_s0_write = 0;


            avs_s0_read = 1;
            #1;


            #1;



            check_outputs(128'hA5, 0, 8'hA5);

            @(posedge clock_clk);
            avs_s0_read = 0;
            #1;
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Write Masking (Higher bits ignored)");
            reset_dut();


            avs_s0_write = 1;
            avs_s0_writedata = 128'hFFFFFFFF_EEEEEEEE_DDDDDDDD_CCCCCCFF;
            @(posedge clock_clk);
            #1;
            avs_s0_write = 0;


            #1;



            check_outputs(128'h0, 0, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Consecutive Writes");
            reset_dut();


            avs_s0_write = 1;
            avs_s0_writedata = 128'h11;
            @(posedge clock_clk);
            #1;

            avs_s0_writedata = 128'h22;
            @(posedge clock_clk);
            #1;

            avs_s0_writedata = 128'h33;
            @(posedge clock_clk);
            #1;
            avs_s0_write = 0;


            avs_s0_read = 1;
            #1;
            #1;

            check_outputs(128'h33, 0, 8'h33);

            @(posedge clock_clk);
            avs_s0_read = 0;
            #1;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Reset mid-operation");
            reset_dut();


            avs_s0_write = 1;
            avs_s0_writedata = 128'h77;
            @(posedge clock_clk);
            #1;
            avs_s0_write = 0;


            reset_reset = 1;
            @(posedge clock_clk);
            #1;
            reset_reset = 0;


            #1;



            check_outputs(128'h0, 0, 8'h00);
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
        input [127:0] expected_avs_s0_readdata;
        input expected_avs_s0_waitrequest;
        input [7:0] expected_led;
        begin
            if (expected_avs_s0_readdata === (expected_avs_s0_readdata ^ avs_s0_readdata ^ expected_avs_s0_readdata) &&
                expected_avs_s0_waitrequest === (expected_avs_s0_waitrequest ^ avs_s0_waitrequest ^ expected_avs_s0_waitrequest) &&
                expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: avs_s0_readdata=%h, avs_s0_waitrequest=%b, led=%h",
                         avs_s0_readdata, avs_s0_waitrequest, led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: avs_s0_readdata=%h, avs_s0_waitrequest=%b, led=%h",
                         expected_avs_s0_readdata, expected_avs_s0_waitrequest, expected_led);
                $display("  Got:      avs_s0_readdata=%h, avs_s0_waitrequest=%b, led=%h",
                         avs_s0_readdata, avs_s0_waitrequest, led);
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
        $dumpvars(0,avs_s0_address, avs_s0_read, avs_s0_write, avs_s0_writedata, clock_clk, reset_reset, avs_s0_readdata, avs_s0_waitrequest, led);
    end

endmodule
