`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] amount;
    reg clk;
    reg [7:0] data;
    reg ena;
    reg load;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .amount(amount),
        .clk(clk),
        .data(data),
        .ena(ena),
        .load(load),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            load = 1;
            ena = 0;
            data = 8'h00;
            amount = 2'b00;
            @(posedge clk);
            #1;
            load = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hA5;
            @(posedge clk);
            #1;
            $display("Test %0d: Synchronous Load 0xA5", test_num);
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h55;
            @(posedge clk);
            #1;
            load = 0;
            ena = 1;
            amount = 2'b00;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift Left 1 bit (0x55 -> 0xAA)", test_num);
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h07;
            @(posedge clk);
            #1;
            load = 0;
            ena = 1;
            amount = 2'b01;
            @(posedge clk);
            #1;
            $display("Test %0d: Shift Left 2 bits (0x07 -> 0x1C)", test_num);
            #1;

            check_outputs(8'h1C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h44;
            @(posedge clk);
            #1;
            load = 0;
            ena = 1;
            amount = 2'b10;
            @(posedge clk);
            #1;
            $display("Test %0d: Arithmetic Right 1 (Positive: 0x44 -> 0x22)", test_num);
            #1;

            check_outputs(8'h22);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h82;
            @(posedge clk);
            #1;
            load = 0;
            ena = 1;
            amount = 2'b10;
            @(posedge clk);
            #1;
            $display("Test %0d: Arithmetic Right 1 (Negative: 0x82 -> 0xC1)", test_num);
            #1;

            check_outputs(8'hC1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hF0;
            @(posedge clk);
            #1;
            load = 0;
            ena = 1;
            amount = 2'b11;
            @(posedge clk);
            #1;
            $display("Test %0d: Arithmetic Right 2 (Negative: 0xF0 -> 0xFC)", test_num);
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'h3C;
            @(posedge clk);
            #1;
            load = 0;
            ena = 0;
            amount = 2'b00;
            @(posedge clk);
            #1;
            $display("Test %0d: Enable signal check (ena=0, data should hold)", test_num);
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 8'hAA;
            @(posedge clk);
            #1;

            load = 1;
            ena = 1;
            data = 8'h55;
            amount = 2'b00;
            @(posedge clk);
            #1;
            $display("Test %0d: Load priority check (load=1, ena=1)", test_num);
            #1;

            check_outputs(8'h55);
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
        testcase008();
        
        
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
        $dumpvars(0,amount, clk, data, ena, load, q);
    end

endmodule
