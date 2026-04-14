`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] A;
    reg [7:0] B;
    reg clk;
    reg clr;
    reg ena;
    reg rst;
    wire [15:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .clr(clr),
        .ena(ena),
        .rst(rst),
        .Z(Z)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            ena = 0;
            clr = 0;
            A = 0;
            B = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();


            #1;



            check_outputs(16'h0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(negedge clk);
            ena = 1;
            clr = 1;
            A = 8'd10;
            B = 8'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(negedge clk);

            ena = 1;
            clr = 1;
            A = 8'd10;
            B = 8'd5;
            @(posedge clk);

            @(negedge clk);
            clr = 0;
            A = 8'd4;
            B = 8'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd62);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            @(negedge clk);

            ena = 1; clr = 1; A = 10; B = 10;
            @(posedge clk);

            @(negedge clk);
            ena = 0; clr = 0; A = 5; B = 5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd100);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            @(negedge clk);

            ena = 1; clr = 1; A = 5; B = 10;
            @(posedge clk);

            @(negedge clk);
            ena = 1; clr = 1; A = 20; B = 2;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd40);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            @(negedge clk);
            ena = 1; clr = 1; A = 8'hFF; B = 8'hFF;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'd65025);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            reset_dut();
            @(negedge clk);
            ena = 1; clr = 1; A = 1; B = 1;
            @(posedge clk);
            clr = 0;
            for(i = 0; i < 9; i = i + 1) begin
                @(negedge clk);
                A = 1; B = 1;
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(16'd10);
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
        input [15:0] expected_Z;
        begin
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
        $dumpvars(0,A, B, clk, clr, ena, rst, Z);
    end

endmodule
