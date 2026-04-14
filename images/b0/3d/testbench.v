`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg reset;
    reg select;
    wire [3:0] counter_q;
    wire [7:0] q;
    wire [7:0] xor_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .reset(reset),
        .select(select),
        .counter_q(counter_q),
        .q(q),
        .xor_out(xor_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            d = 0;
            select = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            #1;

            check_outputs(4'h0, 8'h00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            d = 8'hAA;
            select = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'h0, 8'hAA, 8'hAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            d = 8'h0F;
            select = 0;
            @(posedge clk);


            select = 1;
            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(4'h3, 8'h03, 8'h0C);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            d = 8'h55; select = 0; @(posedge clk);
            select = 1; @(posedge clk);
            #1;


            $display("Checking q with select=1");
            #1;

            check_outputs(4'h1, 8'h01, 8'h54);


            select = 0;
            #1;
            $display("Checking q with select=0");
            #1;

            check_outputs(4'h1, 8'h55, 8'h54);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();
            d = 8'hF0; select = 0; @(posedge clk);

            select = 1;
            for(i=0; i<16; i=i+1) begin
                @(posedge clk);
            end
            #1;



            #1;




            check_outputs(4'h0, 8'h00, 8'hF0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            d = 8'hFF; select = 0; @(posedge clk);

            select = 1;
            repeat(10) @(posedge clk);
            #1;

            #1;


            check_outputs(4'hA, 8'h0A, 8'hF5);
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
        input [3:0] expected_counter_q;
        input [7:0] expected_q;
        input [7:0] expected_xor_out;
        begin
            if (expected_counter_q === (expected_counter_q ^ counter_q ^ expected_counter_q) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_xor_out === (expected_xor_out ^ xor_out ^ expected_xor_out)) begin
                $display("PASS");
                $display("  Outputs: counter_q=%h, q=%h, xor_out=%h",
                         counter_q, q, xor_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: counter_q=%h, q=%h, xor_out=%h",
                         expected_counter_q, expected_q, expected_xor_out);
                $display("  Got:      counter_q=%h, q=%h, xor_out=%h",
                         counter_q, q, xor_out);
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
        $dumpvars(0,clk, d, reset, select, counter_q, q, xor_out);
    end

endmodule
