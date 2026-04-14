`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg bt_in;
    reg clk;
    reg [7:0] data_in;
    wire bt_out;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .bt_in(bt_in),
        .clk(clk),
        .data_in(data_in),
        .bt_out(bt_out),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            bt_in = 0;
            data_in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task drive_serial_in;

        input [7:0] byte_to_send;
        integer i;
        begin
            for (i = 0; i < 8; i = i + 1) begin
                bt_in = byte_to_send[i];
                @(posedge clk);
                #1;
            end
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Basic Data Transfer", test_num);
            data_in = 8'hA5;

            drive_serial_in(8'h3C);


            #1;



            check_outputs(1'b1, 8'h3C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: Alternating Patterns", test_num);
            data_in = 8'h55;
            drive_serial_in(8'hAA);
            #1;

            check_outputs(1'b0, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Zeros", test_num);
            data_in = 8'h00;
            drive_serial_in(8'h00);
            #1;

            check_outputs(1'b0, 8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: All Ones", test_num);
            data_in = 8'hFF;
            drive_serial_in(8'hFF);
            #1;

            check_outputs(1'b1, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            $display("Testcase %0d: High Nibble / Low Nibble", test_num);
            data_in = 8'hF0;
            drive_serial_in(8'h0F);
            #1;

            check_outputs(1'b1, 8'h0F);
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
        input expected_bt_out;
        input [7:0] expected_data_out;
        begin
            if (expected_bt_out === (expected_bt_out ^ bt_out ^ expected_bt_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: bt_out=%b, data_out=%h",
                         bt_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bt_out=%b, data_out=%h",
                         expected_bt_out, expected_data_out);
                $display("  Got:      bt_out=%b, data_out=%h",
                         bt_out, data_out);
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
        $dumpvars(0,bt_in, clk, data_in, bt_out, data_out);
    end

endmodule
