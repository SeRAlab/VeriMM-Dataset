`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg [3:0] multiplicand;
    reg [3:0] multiplier_in;
    reg start;
    wire busy;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .multiplicand(multiplicand),
        .multiplier_in(multiplier_in),
        .start(start),
        .busy(busy),
        .product(product)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            multiplicand = 4'b0000;
            multiplier_in = 4'b0000;
            start = 0;
            @(posedge clock);
            #1;
        end
        endtask
    task run_test;

        input signed [3:0] a;
        input signed [3:0] b;
        input signed [7:0] expected;
        begin
            test_num = test_num + 1;
            $display("Test Case %0d: %d * %d", test_num, a, b);

            multiplicand = a;
            multiplier_in = b;
            start = 1;

            @(posedge clock);
            #1;
            start = 0;


            if (!busy) @(posedge busy);


            while (busy) @(posedge clock);


            #1;
            #1;

            check_outputs(0, expected);
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            run_test(4'd3, 4'd2, 8'd6);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            run_test(4'd7, -4'd3, -8'd21);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            run_test(-4'd4, 4'd5, -8'd20);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            run_test(-4'd2, -4'd3, 8'd6);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            run_test(4'd0, 4'd7, 8'd0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            run_test(4'd5, 4'd0, 8'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            run_test(-4'd8, -4'd8, 8'd64);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            run_test(-4'd8, 4'd7, -8'd56);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            run_test(4'd5, 4'd1, 8'd5);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            run_test(4'd5, -4'd1, -8'd5);
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
        testcase009();
        testcase010();
        
        
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
        input expected_busy;
        input [7:0] expected_product;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, product=%h",
                         busy, product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, product=%h",
                         expected_busy, expected_product);
                $display("  Got:      busy=%b, product=%h",
                         busy, product);
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
        $dumpvars(0,clock, multiplicand, multiplier_in, start, busy, product);
    end

endmodule
