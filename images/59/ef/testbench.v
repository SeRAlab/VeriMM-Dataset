`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] a;
    reg clk;
    reg [15:0] d;
    reg we;
    wire [15:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .clk(clk),
        .d(d),
        .we(we),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 8'h0;
            we <= 1'b0;
            d <= 16'h0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            a = 8'h0A;
            d = 16'h1234;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            d = 16'h0;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();


            a = 8'h10;
            d = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1;


            a = 8'h11;
            d = 16'h5555;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            a = 8'h10;
            #2;

            #1;


            check_outputs(16'hAAAA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();


            a = 8'h20;
            d = 16'hBEEF;
            we = 1;
            @(posedge clk);
            #1;


            a = 8'h20;
            d = 16'hDEAD;
            we = 1;
            @(posedge clk);
            #1;

            we = 0;
            #2;

            #1;


            check_outputs(16'hDEAD);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();


            a = 8'h30;
            d = 16'h7777;
            we = 1;
            @(posedge clk);
            #1;


            we = 0;
            d = 16'h8888;
            @(posedge clk);
            #1;


            a = 8'h30;
            #2;

            #1;


            check_outputs(16'h7777);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            a = 8'hFF;
            d = 16'hFFFF;
            we = 1;
            @(posedge clk);
            #1;

            we = 0;
            #2;

            #1;


            check_outputs(16'hFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();


            a = 8'h40; d = 16'hC0DE; we = 1; @(posedge clk); #1;
            a = 8'h41; d = 16'hFACE; we = 1; @(posedge clk); #1;


            we = 0;
            a = 8'h41;
            #2;

            #1;


            check_outputs(16'hFACE);
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
        input [15:0] expected_q;
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
        $dumpvars(0,a, clk, d, we, q);
    end

endmodule
