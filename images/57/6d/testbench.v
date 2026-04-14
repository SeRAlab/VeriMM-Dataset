`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [99:0] data;
    reg [1:0] ena;
    reg load;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
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
            data = 100'b0;
            ena = 2'b00;
            d = 0;
            @(posedge clk);
            #1;
            load = 0;

            repeat(3) begin
                d = 0;
                @(posedge clk);
                #1;
            end
            $display("DUT Reset Complete");
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 100'h0000000000000000000000005;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(3'b101);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(3'b010);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 100'h2;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(3'b001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 100'h0;
            @(posedge clk);
            #1;
            load = 0;

            d = 1; @(posedge clk); #1;
            d = 1; @(posedge clk); #1;
            d = 0; @(posedge clk); #1;

            #1;


            check_outputs(3'b110);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b10;
            d = 1;
            @(posedge clk);
            #1;



            #1;




            check_outputs(3'b011);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            load = 1;
            data = 100'h1;
            @(posedge clk);
            #1;
            load = 0;
            ena = 2'b01;
            @(posedge clk);
            #1;
            ena = 2'b00;

            #1;


            check_outputs(3'b000);
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
        input [2:0] expected_q;
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
        $dumpvars(0,clk, d, data, ena, load, q);
    end

endmodule
