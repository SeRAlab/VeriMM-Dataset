`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg clk0;
    reg clk1;
    reg clk2;
    reg [1:0] counter_ch;
    reg [31:0] counter_val;
    reg counter_we;
    reg rst;
    wire counter0_OUT;
    wire counter1_OUT;
    wire counter2_OUT;
    wire [31:0] counter_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clk0(clk0),
        .clk1(clk1),
        .clk2(clk2),
        .counter_ch(counter_ch),
        .counter_val(counter_val),
        .counter_we(counter_we),
        .rst(rst),
        .counter0_OUT(counter0_OUT),
        .counter1_OUT(counter1_OUT),
        .counter2_OUT(counter2_OUT),
        .counter_out(counter_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            clk0 = 0;
            clk1 = 0;
            clk2 = 0;
            counter_we = 0;
            counter_ch = 0;
            counter_val = 0;
            repeat(2) @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(0, 0, 0, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            @(posedge clk);
            counter_val = 32'hA5A5A5A5;
            counter_ch = 2'b00;
            counter_we = 1;
            @(posedge clk);
            counter_we = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0, 32'hA5A5A5A5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            @(posedge clk);
            counter_val = 32'h12345678;
            counter_ch = 2'b01;
            counter_we = 1;
            @(posedge clk);
            counter_we = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0, 32'h00000000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            @(posedge clk);
            counter_val = 32'h00000002;
            counter_ch = 2'b00;
            counter_we = 1;
            @(posedge clk);
            counter_we = 0;


            repeat(2) begin
                #10 clk0 = 1; #10 clk0 = 0;
            end
            @(posedge clk);
            #1;

            check_outputs(0, 0, 0, 32'h00000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            @(posedge clk);
            counter_val = 32'h00000000;
            counter_ch = 2'b01;
            counter_we = 1;
            @(posedge clk);
            counter_we = 0;


            #10 clk1 = 1; #10 clk1 = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 1, 0, 32'h00000000);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            @(posedge clk);
            counter_val = 32'hFFFFFFFF;
            counter_ch = 2'b10;
            counter_we = 1;
            @(posedge clk);
            counter_we = 0;
            @(posedge clk);

            #1;


            check_outputs(0, 0, 0, 32'h00000000);
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
        input expected_counter0_OUT;
        input expected_counter1_OUT;
        input expected_counter2_OUT;
        input [31:0] expected_counter_out;
        begin
            if (expected_counter0_OUT === (expected_counter0_OUT ^ counter0_OUT ^ expected_counter0_OUT) &&
                expected_counter1_OUT === (expected_counter1_OUT ^ counter1_OUT ^ expected_counter1_OUT) &&
                expected_counter2_OUT === (expected_counter2_OUT ^ counter2_OUT ^ expected_counter2_OUT) &&
                expected_counter_out === (expected_counter_out ^ counter_out ^ expected_counter_out)) begin
                $display("PASS");
                $display("  Outputs: counter0_OUT=%b, counter1_OUT=%b, counter2_OUT=%b, counter_out=%h",
                         counter0_OUT, counter1_OUT, counter2_OUT, counter_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter0_OUT=%b, counter1_OUT=%b, counter2_OUT=%b, counter_out=%h",
                         expected_counter0_OUT, expected_counter1_OUT, expected_counter2_OUT, expected_counter_out);
                $display("  Got:      counter0_OUT=%b, counter1_OUT=%b, counter2_OUT=%b, counter_out=%h",
                         counter0_OUT, counter1_OUT, counter2_OUT, counter_out);
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
        $dumpvars(0,clk, clk0, clk1, clk2, counter_ch, counter_val, counter_we, rst, counter0_OUT, counter1_OUT, counter2_OUT, counter_out);
    end

endmodule
