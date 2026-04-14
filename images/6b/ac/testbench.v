`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] X;
    reg c;
    reg clk;
    reg clr;
    reg [15:0] data;
    reg sclk;
    reg w;
    wire [15:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .X(X),
        .c(c),
        .clk(clk),
        .clr(clr),
        .data(data),
        .sclk(sclk),
        .w(w),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            clr = 1;
            w = 0;
            data = 0;
            c = 0;
            X = 0;
            sclk = 0;
            @(posedge clk);
            #1;
            clr = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            X = 16'hAAAA;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            w = 1;
            c = 0;
            data = 16'h55AA;
            @(posedge clk);
            w = 0;
            X = 16'hF0F0;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            w = 1;
            c = 1;
            data = 16'hFFFF;
            @(posedge clk);
            w = 0;
            X = 16'h1234;
            repeat(2) @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            X = 16'h1111;

            repeat(4) begin
                sclk = 1; #10;
                sclk = 0; #10;
            end
            @(posedge clk);
            #1;

            check_outputs(16'h0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();


            w = 1; c = 0; data = 16'h0001;
            @(posedge clk);


            w = 1; c = 1; data = 16'h0002;
            @(posedge clk);

            w = 0;
            X = 16'hABCD;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(16'h0000);
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
        input [15:0] expected_Y;
        begin
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
        $dumpvars(0,X, c, clk, clr, data, sclk, w, Y);
    end

endmodule
