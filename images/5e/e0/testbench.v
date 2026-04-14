`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] e;
    reg [9:0] o;
    reg t;
    wire [9:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .e(e),
        .o(o),
        .t(t),
        .s(s)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            o = 0;
            e = 0;
            t = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            o = 10'h3FF;
            e = 4'd5;
            t = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3FF);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            o = 10'h3FF;
            e = 4'd0;
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3FE);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            o = 10'h3FF;
            e = 4'd9;
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h1FF);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            o = 10'h3FF;
            e = 4'd4;
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h3EF);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            o = 10'h2AA;
            e = 4'd12;
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h2AA);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            o = 10'h155;
            e = 4'd2;
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h151);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            o = 10'h155;
            e = 4'd3;
            t = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(10'h155);
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
        input [9:0] expected_s;
        begin
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
        $dumpvars(0,clk, e, o, t, s);
    end

endmodule
