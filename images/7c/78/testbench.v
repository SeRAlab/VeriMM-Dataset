`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clear;
    reg clk;
    reg [7:0] data_in;
    reg load;
    reg serial_in;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clear(clear),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .serial_in(serial_in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clear = 1;
            load = 0;
            serial_in = 0;
            data_in = 0;
            @(posedge clk);
            #1;
            clear = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Clear", test_num);
            reset_dut();

            load = 1; data_in = 8'hFF;
            @(posedge clk); #1;

            load = 0; clear = 1;
            @(posedge clk); #1;
            clear = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Load", test_num);
            reset_dut();
            load = 1;
            data_in = 8'hA5;
            @(posedge clk); #1;
            load = 0;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        integer i;
        reg [7:0] stream;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shifting 8 bits (0xB3)", test_num);
            reset_dut();
            stream = 8'b10110011;
            load = 0;
            clear = 0;

            for (i = 7; i >= 0; i = i - 1) begin
                serial_in = stream[i];
                @(posedge clk); #1;
            end
            #1;

            check_outputs(8'hB3);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Clear priority over Load", test_num);
            reset_dut();
            clear = 1;
            load = 1;
            data_in = 8'hFF;
            @(posedge clk); #1;
            clear = 0; load = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load priority over Shift", test_num);
            reset_dut();
            load = 1;
            data_in = 8'h3C;
            serial_in = 1;
            @(posedge clk); #1;
            load = 0;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase006;

        integer i;
        reg [11:0] stream;
        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Shift 12 bits (Overflow check)", test_num);
            reset_dut();

            stream = 12'b111101011010;
            for (i = 11; i >= 0; i = i - 1) begin
                serial_in = stream[i];
                @(posedge clk); #1;
            end
            #1;

            check_outputs(8'h5A);
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
        input [7:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clear, clk, data_in, load, serial_in, q);
    end

endmodule
