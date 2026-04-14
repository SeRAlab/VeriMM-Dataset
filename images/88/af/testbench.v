`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] address;
    reg [15:0] data_in;
    reg write;
    wire [15:0] LED_datmem;
    wire [15:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .address(address),
        .data_in(data_in),
        .write(write),
        .LED_datmem(LED_datmem),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        write = 0;
        forever #5 write = ~write;
    end

        task reset_dut;

        begin
            address = 16'h0;
            data_in = 16'h0;

            #20;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write/Read...");
            reset_dut();
            address = 16'h0010;
            data_in = 16'hABCD;

            @(posedge write);
            #2;
            #1;

            check_outputs(16'h0000, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Special Address 0xBF00...");
            reset_dut();
            address = 16'hBF00;
            data_in = 16'h1234;
            @(posedge write);
            #2;

            #1;


            check_outputs(16'h1234, 16'h1234);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: LED_datmem Isolation...");
            reset_dut();

            address = 16'hBF00;
            data_in = 16'h55AA;
            @(posedge write);
            #10;

            address = 16'h0020;
            data_in = 16'hFFFF;
            @(posedge write);
            #2;

            #1;


            check_outputs(16'h55AA, 16'hFFFF);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Address 0x00FF...");
            reset_dut();
            address = 16'h00FF;
            data_in = 16'hE001;
            @(posedge write);
            #2;
            #1;

            check_outputs(16'h0000, 16'hE001);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Data Overwrite...");
            reset_dut();
            address = 16'h0005;
            data_in = 16'h1111;
            @(posedge write);
            #10;
            data_in = 16'h2222;
            @(posedge write);
            #2;
            #1;

            check_outputs(16'h0000, 16'h2222);
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
        input [15:0] expected_LED_datmem;
        input [15:0] expected_data_out;
        begin
            if (expected_LED_datmem === (expected_LED_datmem ^ LED_datmem ^ expected_LED_datmem) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: LED_datmem=%h, data_out=%h",
                         LED_datmem, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED_datmem=%h, data_out=%h",
                         expected_LED_datmem, expected_data_out);
                $display("  Got:      LED_datmem=%h, data_out=%h",
                         LED_datmem, data_out);
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
        $dumpvars(0,address, data_in, write, LED_datmem, data_out);
    end

endmodule
