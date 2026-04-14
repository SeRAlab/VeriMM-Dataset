`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg baud_edge;
    reg clk;
    reg [7:0] data;
    reg data_ready;
    reg rst;
    wire data_accepted;
    wire tx;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud_edge(baud_edge),
        .clk(clk),
        .data(data),
        .data_ready(data_ready),
        .rst(rst),
        .data_accepted(data_accepted),
        .tx(tx)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            baud_edge = 0;
            data_ready = 0;
            data = 8'h00;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            repeat(2) @(posedge clk);
        end
        endtask
    task pulse_baud;

        begin
            @(posedge clk);
            #1 baud_edge = 1;
            @(posedge clk);
            #1 baud_edge = 0;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Data Acceptance Pulse", test_num);
            reset_dut();
            data = 8'hAA;
            data_ready = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Start Bit Transmission", test_num);
            reset_dut();
            data = 8'h55;
            data_ready = 1;
            @(posedge clk);
            pulse_baud();
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: LSB Transmission (Data bit 0 = 1)", test_num);
            reset_dut();
            data = 8'h01;
            data_ready = 1;
            @(posedge clk);
            pulse_baud();
            pulse_baud();
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: LSB Transmission (Data bit 0 = 0)", test_num);
            reset_dut();
            data = 8'hFE;
            data_ready = 1;
            @(posedge clk);
            pulse_baud();
            pulse_baud();
            #1;

            #1;


            check_outputs(1'b0, 1'b0);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %0d: Stop Bit Transmission", test_num);
            reset_dut();
            data = 8'h00;
            data_ready = 1;
            @(posedge clk);
            pulse_baud();
            for (i = 0; i < 8; i = i + 1) begin
                pulse_baud();
            end
            pulse_baud();
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %0d: Return to IDLE after STOP bit", test_num);
            reset_dut();
            data = 8'hFF;
            data_ready = 1;
            @(posedge clk);
            pulse_baud();
            for (i = 0; i < 8; i = i + 1) pulse_baud();
            pulse_baud();
            pulse_baud();
            #1;

            #1;


            check_outputs(1'b0, 1'b1);
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
        testcase007();
        
        
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
        input expected_data_accepted;
        input expected_tx;
        begin
            if (expected_data_accepted === (expected_data_accepted ^ data_accepted ^ expected_data_accepted) &&
                expected_tx === (expected_tx ^ tx ^ expected_tx)) begin
                $display("PASS");
                $display("  Outputs: data_accepted=%b, tx=%b",
                         data_accepted, tx);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_accepted=%b, tx=%b",
                         expected_data_accepted, expected_tx);
                $display("  Got:      data_accepted=%b, tx=%b",
                         data_accepted, tx);
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
        $dumpvars(0,baud_edge, clk, data, data_ready, rst, data_accepted, tx);
    end

endmodule
