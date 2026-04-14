`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C;
    reg clk;
    reg reset;
    wire [3:0] q;

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
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            A = 0;
            B = 0;
            C = 0;
            @(posedge clk);
            #1 reset = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 4'd3;
            B = 4'd4;
            C = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd7);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd6);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 4'd12;
            B = 4'd5;
            C = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 4'd2;
            B = 4'd5;
            C = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 4'hF;
            B = 4'hF;
            C = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(4'hE);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 4'h8;
            B = 4'h0;
            C = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'h8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 4'd5; B = 4'd2; C = 1'b0;
            @(posedge clk);
            #1;
            C = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(4'd3);
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
        input [3:0] expected_q;
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
        $dumpvars(0,A, B, C, clk, reset, q);
    end

endmodule
