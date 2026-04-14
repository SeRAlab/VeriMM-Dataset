`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk48;
    reg manchester_data_in;
    wire [7:0] RxData;
    wire end_of_frame;
    wire new_byte_available;
    wire sync_pulse;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk48(clk48),
        .manchester_data_in(manchester_data_in),
        .RxData(RxData),
        .end_of_frame(end_of_frame),
        .new_byte_available(new_byte_available),
        .sync_pulse(sync_pulse)
    );

    // Clock generation (10ns period)
    initial begin
        clk48 = 0;
        forever #5 clk48 = ~clk48;
    end

        task reset_dut;

        begin
            manchester_data_in = 0;
            sync_pulse_latched = 0;
            nba_latched = 0;
            eof_latched = 0;
            repeat(20) @(posedge clk48);
        end
        endtask
    task send_manchester_bit;

        input b;
        begin
            if (b) begin
                manchester_data_in = 1; #50;
                manchester_data_in = 0; #50;
            end else begin
                manchester_data_in = 0; #50;
                manchester_data_in = 1; #50;
            end
        end
        endtask

    task send_byte;

        input [7:0] data;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                send_manchester_bit(data[i]);
            end
        end
        endtask

    task testcase001;

        begin
            $display("Running testcase001: Single Byte Reception (0xA5)");
            reset_dut();


            repeat(2) send_byte(8'h55);

            send_byte(8'hD5);

            send_byte(8'hA5);


            manchester_data_in = 0;
            repeat(50) @(posedge clk48);


            #1;



            check_outputs(8'hA5, eof_latched, nba_latched, sync_pulse_latched);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Multi-Byte Reception (0x12, 0x34)");
            reset_dut();


            repeat(2) send_byte(8'h55);
            send_byte(8'hD5);


            send_byte(8'h12);
            send_byte(8'h34);


            manchester_data_in = 0;
            repeat(50) @(posedge clk48);


            #1;



            check_outputs(8'h34, eof_latched, nba_latched, sync_pulse_latched);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: End of Frame Detection");
            reset_dut();


            send_byte(8'hD5);

            send_byte(8'hFF);


            manchester_data_in = 1;
            repeat(100) @(posedge clk48);


            #1;



            check_outputs(8'hFF, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Byte 0x00 Reception");
            reset_dut();

            send_byte(8'hD5);
            send_byte(8'h00);

            manchester_data_in = 0;
            repeat(50) @(posedge clk48);

            #1;


            check_outputs(8'h00, eof_latched, nba_latched, sync_pulse_latched);
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
        input [7:0] expected_RxData;
        input expected_end_of_frame;
        input expected_new_byte_available;
        input expected_sync_pulse;
        begin
            if (expected_RxData === (expected_RxData ^ RxData ^ expected_RxData) &&
                expected_end_of_frame === (expected_end_of_frame ^ end_of_frame ^ expected_end_of_frame) &&
                expected_new_byte_available === (expected_new_byte_available ^ new_byte_available ^ expected_new_byte_available) &&
                expected_sync_pulse === (expected_sync_pulse ^ sync_pulse ^ expected_sync_pulse)) begin
                $display("PASS");
                $display("  Outputs: RxData=%h, end_of_frame=%b, new_byte_available=%b, sync_pulse=%b",
                         RxData, end_of_frame, new_byte_available, sync_pulse);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: RxData=%h, end_of_frame=%b, new_byte_available=%b, sync_pulse=%b",
                         expected_RxData, expected_end_of_frame, expected_new_byte_available, expected_sync_pulse);
                $display("  Got:      RxData=%h, end_of_frame=%b, new_byte_available=%b, sync_pulse=%b",
                         RxData, end_of_frame, new_byte_available, sync_pulse);
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
        $dumpvars(0,clk48, manchester_data_in, RxData, end_of_frame, new_byte_available, sync_pulse);
    end

endmodule
