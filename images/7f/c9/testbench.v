`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg pop_en;
    reg reset;
    reg write_en;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .pop_en(pop_en),
        .reset(reset),
        .write_en(write_en),
        .data_out(data_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            write_en = 0;
            pop_en = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic Push and Idle Output", test_num);
            reset_dut();

            write_en = 1; data_in = 8'hAA; @(posedge clk);
            write_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Push Two, Pop One", test_num);
            reset_dut();

            write_en = 1; data_in = 8'h11; @(posedge clk);

            write_en = 1; data_in = 8'h22; @(posedge clk);
            write_en = 0; @(posedge clk);

            pop_en = 1; @(posedge clk);
            pop_en = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h11);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill Stack to Depth 16", test_num);
            reset_dut();
            for (i = 0; i < 16; i = i + 1) begin
                write_en = 1; data_in = i[7:0]; @(posedge clk);
            end
            write_en = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(8'd15);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Stack Wrap-around (17 entries)", test_num);
            reset_dut();

            for (i = 0; i < 16; i = i + 1) begin
                write_en = 1; data_in = i[7:0]; @(posedge clk);
            end

            write_en = 1; data_in = 8'hFF; @(posedge clk);
            write_en = 0; @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Interleaved Push and Pop", test_num);
            reset_dut();

            write_en = 1; data_in = 8'h0A; @(posedge clk);

            write_en = 1; data_in = 8'h0B; @(posedge clk);

            write_en = 0; pop_en = 1; @(posedge clk);

            pop_en = 0; write_en = 1; data_in = 8'h0C; @(posedge clk);

            write_en = 0; pop_en = 1; @(posedge clk);

            pop_en = 1; @(posedge clk);
            pop_en = 0; @(posedge clk);
            #1;

            #1;


            check_outputs(8'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Data Output During Pop Pulse", test_num);
            reset_dut();

            write_en = 1; data_in = 8'h55; @(posedge clk);
            write_en = 0; @(posedge clk);

            pop_en = 1;
            #1;
            #1;

            check_outputs(8'h55);
            @(posedge clk);
            pop_en = 0;
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
        input [7:0] expected_data_out;
        begin
            if (expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: data_out=%h",
                         data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: data_out=%h",
                         expected_data_out);
                $display("  Got:      data_out=%h",
                         data_out);
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
        $dumpvars(0,clk, data_in, pop_en, reset, write_en, data_out);
    end

endmodule
