`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Sclk;
    reg [39:0] a;
    reg add_sub;
    reg adder_en;
    reg [39:0] b;
    wire [39:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Sclk(Sclk),
        .a(a),
        .add_sub(add_sub),
        .adder_en(adder_en),
        .b(b),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        Sclk = 0;
        forever #5 Sclk = ~Sclk;
    end

        task reset_dut;

        begin
            a = 40'd0;
            b = 40'd0;
            add_sub = 1'b1;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;
            adder_en = 1'b0;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            a = 40'h000000000A;
            b = 40'h0000000014;
            add_sub = 1'b1;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;
            #1;

            check_outputs(40'h000000001E);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            a = 40'h0000000064;
            b = 40'h0000000028;
            add_sub = 1'b0;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;
            #1;

            check_outputs(40'h000000003C);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;

            a = 40'd5;
            b = 40'd5;
            add_sub = 1'b1;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;


            a = 40'd50;
            b = 40'd50;
            adder_en = 1'b0;
            @(posedge Sclk);
            #1;
            #1;

            check_outputs(40'd10);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            a = 40'hFFFFFFFFFF;
            b = 40'h0000000001;
            add_sub = 1'b1;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;
            #1;

            check_outputs(40'h0000000000);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            a = 40'h0000000000;
            b = 40'h0000000001;
            add_sub = 1'b0;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;
            #1;

            check_outputs(40'hFFFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            a = 40'hAABBCCDDEE;
            b = 40'h1122334455;
            add_sub = 1'b1;
            adder_en = 1'b1;
            @(posedge Sclk);
            #1;
            #1;

            check_outputs(40'hBBDFEE2243);
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
        input [39:0] expected_sum;
        begin
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
        $dumpvars(0,Sclk, a, add_sub, adder_en, b, sum);
    end

endmodule
