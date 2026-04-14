`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] A;
    reg clk;
    wire [7:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .clk(clk),
        .Y(Y)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 3'b000;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            A = 3'd0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1111_1110);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            A = 3'd1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1111_1101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            A = 3'd2;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1111_1011);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            A = 3'd3;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1111_0111);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            A = 3'd4;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1110_1111);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            A = 3'd5;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1101_1111);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            A = 3'd6;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b1011_1111);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            A = 3'd7;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'b0111_1111);
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
        input [7:0] expected_Y;
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
        $dumpvars(0,A, clk, Y);
    end

endmodule
