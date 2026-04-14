`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk8x;
    reg [255:0] data_frame;
    reg shift_enable;
    wire frame_sync;
    wire sdo;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk8x(clk8x),
        .data_frame(data_frame),
        .shift_enable(shift_enable),
        .frame_sync(frame_sync),
        .sdo(sdo)
    );

    // Clock generation (10ns period)
    initial begin
        clk8x = 0;
        forever #5 clk8x = ~clk8x;
    end

        task reset_dut;

        begin
            shift_enable = 0;
            data_frame = 0;
            repeat(2) @(posedge clk8x);
        end
        endtask
    task run_serial_test;

        input [255:0] df;
        input expected_last_bit;
        integer i;
        begin
            test_num = test_num + 1;
            data_frame = df;
            shift_enable = 1;


            @(posedge clk8x);
            #1;
            shift_enable = 0;


            for (i = 0; i < 255; i = i + 1) begin
                @(posedge clk8x);
            end


            #1;
            #1;

            check_outputs(1'b0, expected_last_bit);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_serial_test({256{1'b1}}, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_serial_test({256{1'b0}}, 1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_serial_test({64{4'hA}}, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_serial_test({64{4'h5}}, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_serial_test(256'h0000000000000000000000000000000000000000000000000000000000000001, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_serial_test(256'h8000000000000000000000000000000000000000000000000000000000000000, 1'b0);
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
        input expected_frame_sync;
        input expected_sdo;
        begin
            if (expected_frame_sync === (expected_frame_sync ^ frame_sync ^ expected_frame_sync) &&
                expected_sdo === (expected_sdo ^ sdo ^ expected_sdo)) begin
                $display("PASS");
                $display("  Outputs: frame_sync=%b, sdo=%b",
                         frame_sync, sdo);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: frame_sync=%b, sdo=%b",
                         expected_frame_sync, expected_sdo);
                $display("  Got:      frame_sync=%b, sdo=%b",
                         frame_sync, sdo);
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
        $dumpvars(0,clk8x, data_frame, shift_enable, frame_sync, sdo);
    end

endmodule
