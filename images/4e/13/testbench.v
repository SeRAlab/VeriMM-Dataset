`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg SUB;
    reg clk;
    reg load;
    reg reset;
    reg [2:0] shift_in;
    wire [3:0] SUM;
    wire [2:0] shift_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .SUB(SUB),
        .clk(clk),
        .load(load),
        .reset(reset),
        .shift_in(shift_in),
        .SUM(SUM),
        .shift_out(shift_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;
            SUB = 0;
            load = 0;
            shift_in = 0;
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(4'b0000, 3'b000);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            A = 4'd5;
            B = 4'd3;
            SUB = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd8, 3'b000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            A = 4'd10;
            B = 4'd4;
            SUB = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd6, 3'b000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            load = 1;
            shift_in = 3'b101;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 3'b101);
        end
        endtask

    task testcase005;

        begin
            reset_dut();

            load = 1;
            shift_in = 3'b011;
            @(posedge clk);

            load = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 3'b110);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            A = 4'd15;
            B = 4'd1;
            SUB = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 3'b000);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            A = 4'd2;
            B = 4'd5;
            SUB = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd13, 3'b000);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            A = 4'd7;
            B = 4'd2;
            SUB = 0;
            load = 1;
            shift_in = 3'b111;
            @(posedge clk);
            #1 #1;
 check_outputs(4'd9, 3'b111);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            load = 1;
            shift_in = 3'b001;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 3'b100);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            load = 1;
            shift_in = 3'b100;
            @(posedge clk);
            load = 0;
            @(posedge clk);
            @(posedge clk);
            #1 #1;
 check_outputs(4'd0, 3'b000);
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
        input [3:0] expected_SUM;
        input [2:0] expected_shift_out;
        begin
            if (expected_SUM === (expected_SUM ^ SUM ^ expected_SUM) &&
                expected_shift_out === (expected_shift_out ^ shift_out ^ expected_shift_out)) begin
                $display("PASS");
                $display("  Outputs: SUM=%h, shift_out=%h",
                         SUM, shift_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: SUM=%h, shift_out=%h",
                         expected_SUM, expected_shift_out);
                $display("  Got:      SUM=%h, shift_out=%h",
                         SUM, shift_out);
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
        $dumpvars(0,A, B, SUB, clk, load, reset, shift_in, SUM, shift_out);
    end

endmodule
