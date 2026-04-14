`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] in;
    wire [7:0] out_I;
    wire [7:0] out_Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .out_I(out_I),
        .out_Q(out_Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            in = 8'h00;
            @(posedge clk);
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            in = 8'h10;
            @(posedge clk);
            #2;
            in = 8'h20;
            #1;


            #1;



            check_outputs(8'h30, 8'hEF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            in = 8'h00;
            @(posedge clk);
            #2;
            in = 8'hFF;
            #1;


            #1;



            check_outputs(8'hFF, 8'h00);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            in = 8'h55;
            @(posedge clk);
            #2;
            in = 8'hAA;
            #1;


            #1;



            check_outputs(8'hFF, 8'hAA);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            in = 8'h80;
            @(posedge clk);
            #2;
            in = 8'h80;
            #1;


            #1;



            check_outputs(8'h00, 8'hFF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            in = 8'hFF;
            @(posedge clk);
            #2;
            in = 8'h00;
            #1;


            #1;



            check_outputs(8'hFF, 8'hFE);
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
        input [7:0] expected_out_I;
        input [7:0] expected_out_Q;
        begin
            if (expected_out_I === (expected_out_I ^ out_I ^ expected_out_I) &&
                expected_out_Q === (expected_out_Q ^ out_Q ^ expected_out_Q)) begin
                $display("PASS");
                $display("  Outputs: out_I=%h, out_Q=%h",
                         out_I, out_Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_I=%h, out_Q=%h",
                         expected_out_I, expected_out_Q);
                $display("  Got:      out_I=%h, out_Q=%h",
                         out_I, out_Q);
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
        $dumpvars(0,clk, in, out_I, out_Q);
    end

endmodule
