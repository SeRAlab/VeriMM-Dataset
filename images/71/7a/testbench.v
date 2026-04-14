`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cs;
    reg mosi;
    reg [7:0] ret_data;
    reg rst_n;
    reg sck;
    wire [7:0] ctl;
    wire [7:0] data;
    wire miso;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cs(cs),
        .mosi(mosi),
        .ret_data(ret_data),
        .rst_n(rst_n),
        .sck(sck),
        .ctl(ctl),
        .data(data),
        .miso(miso)
    );

    // Clock generation (10ns period)
    initial begin
        cs = 0;
        forever #5 cs = ~cs;
    end

        task reset_dut;

        begin
            rst_n = 0;
            sck = 0;
            mosi = 0;
            ret_data = 8'h00;


            #20;
            rst_n = 1;
            #20;
        end
        endtask
    task send_byte;

        input [7:0] val;
        integer i;
        begin
            for (i = 7; i >= 0; i = i - 1) begin
                mosi = val[i];
                #10;
                sck = 1;
                #10;
                sck = 0;
            end
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Basic Write (0xA5, 0x5A)");
            reset_dut();
            test_num = 1;



            force cs = 0;
            send_byte(8'hA5);
            send_byte(8'h5A);
            release cs;
            force cs = 1;
            #20;



            #1;




            check_outputs(8'hA5, 8'h5A, miso);
            release cs;
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Extreme Patterns (0xFF, 0x00)");
            reset_dut();
            test_num = 2;

            force cs = 0;
            send_byte(8'hFF);
            send_byte(8'h00);
            release cs;
            force cs = 1;
            #20;

            #1;


            check_outputs(8'hFF, 8'h00, miso);
            release cs;
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Reset Verification");
            reset_dut();
            test_num = 3;


            #1;



            check_outputs(8'h00, 8'h00, miso);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Successive Writes");
            reset_dut();
            test_num = 4;


            force cs = 0;
            send_byte(8'h12);
            send_byte(8'h34);
            release cs;
            force cs = 1;
            #20;


            force cs = 0;
            send_byte(8'hDE);
            send_byte(8'hAD);
            release cs;
            force cs = 1;
            #20;

            #1;


            check_outputs(8'hDE, 8'hAD, miso);
            release cs;
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
        input [7:0] expected_ctl;
        input [7:0] expected_data;
        input expected_miso;
        begin
            if (expected_ctl === (expected_ctl ^ ctl ^ expected_ctl) &&
                expected_data === (expected_data ^ data ^ expected_data) &&
                expected_miso === (expected_miso ^ miso ^ expected_miso)) begin
                $display("PASS");
                $display("  Outputs: ctl=%h, data=%h, miso=%b",
                         ctl, data, miso);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctl=%h, data=%h, miso=%b",
                         expected_ctl, expected_data, expected_miso);
                $display("  Got:      ctl=%h, data=%h, miso=%b",
                         ctl, data, miso);
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
        $dumpvars(0,cs, mosi, ret_data, rst_n, sck, ctl, data, miso);
    end

endmodule
