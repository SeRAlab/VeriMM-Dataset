`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [15:0] A;
    reg [15:0] B;
    reg C;
    reg clk;
    reg [3:0] data_in;
    reg load;
    reg reset;
    reg shift;
    wire [15:0] Q;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .C(C),
        .clk(clk),
        .data_in(data_in),
        .load(load),
        .reset(reset),
        .shift(shift),
        .Q(Q),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0; B = 0; C = 0;
            data_in = 0; load = 0; shift = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;

            A = 16'hAAAA; B = 16'h5555; C = 0;
            data_in = 4'hF; load = 1;
            reset_dut();

            #1;


            check_outputs(16'h0000, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 16'h1234; B = 16'h1111; C = 0;
            load = 1; data_in = 4'hD;
            shift = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h2345, 4'hD);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();

            load = 1; data_in = 4'b1011;
            @(posedge clk);
            #1;

            A = 16'h0020; B = 16'h0005; C = 1;
            load = 0; shift = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h001B, 4'h5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            load = 1; data_in = 4'hF;
            @(posedge clk);
            #1;


            A = 16'h000A; B = 16'h0000; C = 0;
            load = 0; shift = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h000A, 4'hA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            load = 1; data_in = 4'h8;
            @(posedge clk);
            #1;

            load = 1; shift = 1; data_in = 4'h3;
            A = 16'h0001; B = 16'h0001; C = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'h0002, 4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            load = 1; data_in = 4'h7;
            @(posedge clk);
            #1;



            A = 16'h0005; B = 16'h000A; C = 1;
            load = 0; shift = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(16'hFFFB, 4'h3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            load = 1; data_in = 4'hF;
            @(posedge clk);
            #1;

            A = 16'hFFFF; B = 16'h0001; C = 0;
            load = 0; shift = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'h0000, 4'h0);
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
        input [15:0] expected_Q;
        input [3:0] expected_out;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, out=%h",
                         Q, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, out=%h",
                         expected_Q, expected_out);
                $display("  Got:      Q=%h, out=%h",
                         Q, out);
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
        $dumpvars(0,A, B, C, clk, data_in, load, reset, shift, Q, out);
    end

endmodule
