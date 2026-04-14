`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg clk;
    reg reset;
    reg select;
    wire [7:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .reset(reset),
        .select(select),
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
            a = 0;
            b = 0;
            select = 0;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Reset Check", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Addition (5 + 3)", test_num);
            reset_dut();
            a = 4'h5;
            b = 4'h3;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h08);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Addition with Carry (15 + 15)", test_num);
            reset_dut();
            a = 4'hF;
            b = 4'hF;
            select = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(8'h1E);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Register Hold Mode", test_num);
            reset_dut();


            a = 4'h4;
            b = 4'h2;
            select = 0;
            @(posedge clk);
            #1;


            a = 4'hA;
            b = 4'hB;
            select = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h06);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Sequence Operation (Add -> Hold -> Add)", test_num);
            reset_dut();


            a = 4'hA; b = 4'h2; select = 0;
            @(posedge clk); #1;


            a = 4'h0; b = 4'h0; select = 1;
            @(posedge clk); #1;


            a = 4'h1; b = 4'h1; select = 0;
            @(posedge clk); #1;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Priority", test_num);
            reset_dut();


            a = 4'hF; b = 4'hF; select = 0;
            reset = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(8'h00);
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
        input [7:0] expected_q;
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
        $dumpvars(0,a, b, clk, reset, select, q);
    end

endmodule
