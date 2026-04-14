`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [6:0] adr;
    reg reset;
    reg scl;
    wire debug;
    wire [7:0] ioout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .adr(adr),
        .reset(reset),
        .scl(scl),
        .debug(debug),
        .ioout(ioout)
    );

    // Clock generation (10ns period)
    initial begin
        reset = 0;
        forever #5 reset = ~reset;
    end

        task reset_dut;

        begin
            scl = 1;
            sda_oe = 0;
            sda_out = 1;
            adr = 7'h00;
            #40;
        end
        endtask
    task i2c_start;

        begin
            sda_oe = 1; sda_out = 1; scl = 1; #20;
            sda_out = 0; #20;
            scl = 0; #20;
        end
        endtask

    task i2c_stop;

        begin
            sda_oe = 1; sda_out = 0; #20;
            scl = 1; #20;
            sda_out = 1; #20;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            adr = 7'h27;
            #20;
            i2c_start();
            i2c_write_byte({7'h27, 1'b0});
            i2c_write_byte(8'hA5);
            i2c_stop();
            #50;
            $display("Testcase 001: Basic Write 0xA5 to Address 0x27");
            #1;

            check_outputs(1'b1, 8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            adr = 7'h50;
            #20;
            i2c_start();
            i2c_write_byte({7'h27, 1'b0});
            i2c_write_byte(8'hFF);
            i2c_stop();
            #50;
            $display("Testcase 002: Write to Wrong Address (Expected no change)");
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            adr = 7'h12;
            #20;

            i2c_start();
            i2c_write_byte({7'h12, 1'b0});
            i2c_write_byte(8'h11);
            i2c_stop();
            #20;

            i2c_start();
            i2c_write_byte({7'h12, 1'b0});
            i2c_write_byte(8'h22);
            i2c_stop();
            #50;
            $display("Testcase 003: Successive Write 0x11 then 0x22");
            #1;

            check_outputs(1'b1, 8'h22);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            adr = 7'h33;
            #20;
            i2c_start();
            i2c_write_byte({7'h33, 1'b0});
            i2c_write_byte(8'hDE);
            i2c_write_byte(8'hAD);
            i2c_stop();
            #50;
            $display("Testcase 004: Multi-byte Write (Check last byte)");
            #1;

            check_outputs(1'b1, 8'hAD);
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
        input expected_debug;
        input [7:0] expected_ioout;
        begin
            if (expected_debug === (expected_debug ^ debug ^ expected_debug) &&
                expected_ioout === (expected_ioout ^ ioout ^ expected_ioout)) begin
                $display("PASS");
                $display("  Outputs: debug=%b, ioout=%h",
                         debug, ioout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: debug=%b, ioout=%h",
                         expected_debug, expected_ioout);
                $display("  Got:      debug=%b, ioout=%h",
                         debug, ioout);
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
        $dumpvars(0,adr, reset, scl, debug, ioout);
    end

endmodule
