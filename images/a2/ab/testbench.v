`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg data_request;
    reg [2:0] key_data;
    reg key_en;
    reg reset;
    wire data_ready;
    wire [2:0] sound_code;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .data_request(data_request),
        .key_data(key_data),
        .key_en(key_en),
        .reset(reset),
        .data_ready(data_ready),
        .sound_code(sound_code)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            reset = 1;
            key_data = 0;
            key_en = 0;
            data_request = 0;
            #20;
            reset = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic normal operation", test_num);
            reset_dut();

            @(posedge clock);
            data_request = 1;
            @(posedge clock);
            data_request = 0;

            @(posedge clock);
            key_data = 3'b101;
            key_en = 1;
            @(posedge clock);
            key_en = 0;


            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Different key data input", test_num);
            reset_dut();

            @(posedge clock);
            data_request = 1;
            @(posedge clock);
            data_request = 0;

            @(posedge clock);
            key_data = 3'b011;
            key_en = 1;
            @(posedge clock);
            key_en = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Capture delay without key_en", test_num);
            reset_dut();

            @(posedge clock);
            data_request = 1;
            @(posedge clock);
            data_request = 0;


            @(posedge clock);
            key_data = 3'b111;
            key_en = 0;
            @(posedge clock);


            key_en = 1;
            @(posedge clock);
            key_en = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No trigger without request", test_num);
            reset_dut();


            @(posedge clock);
            key_data = 3'b110;
            key_en = 1;
            @(posedge clock);
            key_en = 0;

            @(posedge clock);
            #1;


            #1;



            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();

            @(posedge clock);
            data_request = 1;
            @(posedge clock);
            data_request = 0;

            @(posedge clock);
            key_data = 3'b100;
            key_en = 1;


            reset = 1;
            @(posedge clock);
            reset = 0;

            @(posedge clock);
            #1;

            #1;


            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Key data update before capture", test_num);
            reset_dut();

            @(posedge clock);
            data_request = 1;
            @(posedge clock);
            data_request = 0;

            @(posedge clock);
            key_data = 3'b001;
            @(posedge clock);
            key_data = 3'b110;
            key_en = 1;
            @(posedge clock);
            key_en = 0;

            @(posedge clock);
            #1;
            #1;

            check_outputs(1'b1, 3'b110);
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
        input expected_data_ready;
        input [2:0] expected_sound_code;
        begin
            if (expected_data_ready === (expected_data_ready ^ data_ready ^ expected_data_ready) &&
                expected_sound_code === (expected_sound_code ^ sound_code ^ expected_sound_code)) begin
                $display("PASS");
                $display("  Outputs: data_ready=%b, sound_code=%h",
                         data_ready, sound_code);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_ready=%b, sound_code=%h",
                         expected_data_ready, expected_sound_code);
                $display("  Got:      data_ready=%b, sound_code=%h",
                         data_ready, sound_code);
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
        $dumpvars(0,clock, data_request, key_data, key_en, reset, data_ready, sound_code);
    end

endmodule
