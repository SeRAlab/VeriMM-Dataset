`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] addr;
    reg clk;
    reg [7:0] data_in;
    reg write;
    wire [7:0] data_out;
    wire [7:0] led_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .addr(addr),
        .clk(clk),
        .data_in(data_in),
        .write(write),
        .data_out(data_out),
        .led_out(led_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            addr = 0;
            data_in = 0;
            write = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            $display("Testcase 001: Write 0xA5 to address 0x10");
            addr = 8'h10;
            data_in = 8'hA5;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;



            #1;




            check_outputs(8'hA5, led_out);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            $display("Testcase 002: Write 0x3C to address 0xFF (LED address)");
            addr = 8'hFF;
            data_in = 8'h3C;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;
            #1;

            check_outputs(8'h3C, 8'h3C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            addr = 8'hFF;
            data_in = 8'hAA;
            write = 1;
            @(posedge clk);
            #1;

            addr = 8'h20;
            data_in = 8'h55;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;

            #1;


            check_outputs(8'h55, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            addr = 8'h01;
            data_in = 8'h11;
            write = 1;
            @(posedge clk);
            #1;

            addr = 8'h02;
            data_in = 8'h22;
            write = 1;
            @(posedge clk);
            #1;
            write = 0;

            addr = 8'h01;
            #1;
            #1;

            check_outputs(8'h11, led_out);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            addr = 8'h30;
            data_in = 8'h77;
            write = 1;
            @(posedge clk);
            #1;

            addr = 8'h30;
            data_in = 8'h88;
            write = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h77, led_out);
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
        input [7:0] expected_data_out;
        input [7:0] expected_led_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_led_out === (expected_led_out ^ led_out ^ expected_led_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h, led_out=%h",
                         data_out, led_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h, led_out=%h",
                         expected_data_out, expected_led_out);
                $display("  Got:      data_out=%h, led_out=%h",
                         data_out, led_out);
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
        $dumpvars(0,addr, clk, data_in, write, data_out, led_out);
    end

endmodule
