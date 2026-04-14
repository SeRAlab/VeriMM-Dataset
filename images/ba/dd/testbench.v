`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg [3:0] num1;
    reg [3:0] num2;
    wire [3:0] larger;
    wire [3:0] q;
    wire [7:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .num1(num1),
        .num2(num2),
        .larger(larger),
        .q(q),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            load = 0;
            data_in = 4'b0;
            num1 = 4'b0;
            num2 = 4'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            load = 1;
            data_in = 4'hA;
            num1 = 4'd10;
            num2 = 4'd5;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hA, 4'hA, 8'h14);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();

            load = 1;
            data_in = 4'h3;
            num1 = 4'd4;
            num2 = 4'd12;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hC, 4'h3, 8'h0F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            load = 1;
            data_in = 4'hF;
            num1 = 4'd7;
            num2 = 4'd7;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h7, 4'hF, 8'h16);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            load = 1;
            data_in = 4'hF;
            num1 = 4'hF;
            num2 = 4'hF;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'hF, 4'hF, 8'h1E);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            load = 1;
            data_in = 4'h0;
            num1 = 4'h0;
            num2 = 4'h0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(4'h0, 4'h0, 8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();

            load = 1;
            data_in = 4'b0001;
            num1 = 4'd5;
            num2 = 4'd5;
            @(posedge clk);
            #2;


            load = 0;
            num1 = 4'd5;
            num2 = 4'd5;
            @(posedge clk);
            #2;



            #1;




            check_outputs(4'h5, 4'h2, 8'h07);
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
        input [3:0] expected_larger;
        input [3:0] expected_q;
        input [7:0] expected_sum;
        begin
            if (expected_larger === (expected_larger ^ larger ^ expected_larger) &&
                expected_q === (expected_q ^ q ^ expected_q) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: larger=%h, q=%h, sum=%h",
                         larger, q, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: larger=%h, q=%h, sum=%h",
                         expected_larger, expected_q, expected_sum);
                $display("  Got:      larger=%h, q=%h, sum=%h",
                         larger, q, sum);
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
        $dumpvars(0,clk, data_in, load, num1, num2, larger, q, sum);
    end

endmodule
