`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_SD;
    reg [39:0] command;
    reg enable_stp;
    reg reset_stp;
    reg signal_in;
    wire serial_complete;
    wire [135:0] signal_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_SD(clk_SD),
        .command(command),
        .enable_stp(enable_stp),
        .reset_stp(reset_stp),
        .signal_in(signal_in),
        .serial_complete(serial_complete),
        .signal_out(signal_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_SD = 0;
        forever #5 clk_SD = ~clk_SD;
    end

        task reset_dut;

        begin
            reset_stp = 1;
            enable_stp = 0;
            command = 0;
            signal_in = 0;
            repeat(2) @(posedge clk_SD);
            #1 reset_stp = 0;
            @(posedge clk_SD);
        end
        endtask
    task shift_bits;

        input [135:0] data;
        input integer count;
        integer i;
        begin
            for (i = count - 1; i >= 0; i = i - 1) begin
                signal_in = data[i];
                @(posedge clk_SD);
                #1;
            end
        end
        endtask

    task testcase001;

        reg [135:0] test_data;
        begin
            test_num = 1;
            $display("Testcase %03d: 40-bit Serial-to-Parallel Conversion", test_num);
            reset_dut();

            command = 40'h0000000001;
            test_data = 136'h0000000000_ABCDE12345;
            enable_stp = 1;

            shift_bits(test_data, 40);


            #1;



            check_outputs(1'b1, 136'h0000000000_ABCDE12345);
        end
        endtask

    task testcase002;

        reg [135:0] test_data;
        begin
            test_num = 2;
            $display("Testcase %03d: 136-bit Serial-to-Parallel Conversion", test_num);
            reset_dut();

            command = 40'h0000000002;
            test_data = 136'hFEDCBA9876543210FEDCBA9876543210FF;
            enable_stp = 1;

            shift_bits(test_data, 136);

            #1;


            check_outputs(1'b1, 136'hFEDCBA9876543210FEDCBA9876543210FF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Operation while enable_stp is low", test_num);
            reset_dut();

            command = 40'h0000000001;
            enable_stp = 0;
            signal_in = 1;

            repeat(10) @(posedge clk_SD);


            #1;



            check_outputs(1'b0, 136'h0);
        end
        endtask

    task testcase004;

        reg [135:0] test_data;
        begin
            test_num = 4;
            $display("Testcase %03d: Reset mid-operation", test_num);
            reset_dut();

            command = 40'h0000000002;
            test_data = 136'hAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA;
            enable_stp = 1;

            shift_bits(test_data, 60);

            reset_stp = 1;
            @(posedge clk_SD);
            #1 reset_stp = 0;


            #1;



            check_outputs(1'b0, 136'h0);
        end
        endtask

    task testcase005;

        reg [135:0] data1, data2;
        begin
            test_num = 5;
            $display("Testcase %03d: Back-to-back 40-bit then 136-bit", test_num);
            reset_dut();


            command = 40'h0000000001;
            data1 = 136'h0000000000_1234567890;
            enable_stp = 1;
            shift_bits(data1, 40);


            reset_dut();
            command = 40'h0000000002;
            data2 = 136'h55555555555555555555555555555555AA;
            enable_stp = 1;
            shift_bits(data2, 136);

            #1;


            check_outputs(1'b1, 136'h55555555555555555555555555555555AA);
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
        input expected_serial_complete;
        input [135:0] expected_signal_out;
        begin
            if (expected_serial_complete === (expected_serial_complete ^ serial_complete ^ expected_serial_complete) &&
                expected_signal_out === (expected_signal_out ^ signal_out ^ expected_signal_out)) begin
                $display("PASS");
                $display("  Outputs: serial_complete=%b, signal_out=%h",
                         serial_complete, signal_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: serial_complete=%b, signal_out=%h",
                         expected_serial_complete, expected_signal_out);
                $display("  Got:      serial_complete=%b, signal_out=%h",
                         serial_complete, signal_out);
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
        $dumpvars(0,clk_SD, command, enable_stp, reset_stp, signal_in, serial_complete, signal_out);
    end

endmodule
