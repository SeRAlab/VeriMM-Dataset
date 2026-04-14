`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] d;
    reg [2:0] in;
    wire [10:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .in(in),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 3'b000;
            d = 8'h00;
            @(posedge clk);
            @(negedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            in = 3'b001;
            d = 8'hA5;


            @(posedge clk);
            @(negedge clk);
            #2;



            #1;




            check_outputs(11'b001_10100101);
        end
        endtask

    task testcase002;

        begin
            reset_dut();


            in = 3'b001; d = 8'hFF;
            @(posedge clk); @(negedge clk);


            in = 3'b000; d = 8'h55;
            @(posedge clk); @(negedge clk);

            #2;


            #1;



            check_outputs(11'b010_01010101);
        end
        endtask

    task testcase003;

        begin
            reset_dut();


            in = 3'b001; d = 8'h00;
            @(posedge clk); @(negedge clk);

            in = 3'b001; d = 8'h00;
            @(posedge clk); @(negedge clk);

            in = 3'b001; d = 8'hAA;
            @(posedge clk); @(negedge clk);

            #2;

            #1;


            check_outputs(11'b111_10101010);
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
        input [10:0] expected_q;
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
        $dumpvars(0,clk, d, in, q);
    end

endmodule
