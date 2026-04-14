`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg EN;
    reg clk_cin;
    reg load;
    reg [3:0] preset;
    reg rst;
    wire cout;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .EN(EN),
        .clk_cin(clk_cin),
        .load(load),
        .preset(preset),
        .rst(rst),
        .cout(cout),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk_cin = 0;
        forever #5 clk_cin = ~clk_cin;
    end

        task reset_dut;

        begin
            rst = 1;
            EN = 0;
            load = 0;
            preset = 4'b0000;
            @(posedge clk_cin);
            #2 rst = 0;
            @(posedge clk_cin);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            load = 1;
            preset = 4'd5;
            @(posedge clk_cin);
            #1 load = 0;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            EN = 1;
            @(posedge clk_cin);
            #1 #1;
 check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            EN = 1;
            @(posedge clk_cin);
            #1 EN = 0;
            repeat(2) @(posedge clk_cin);
            #1 #1;
 check_outputs(1'b0, 4'd1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            load = 1;
            preset = 4'd9;
            @(posedge clk_cin);
            #1 load = 0;
            EN = 1;
            #1 #1;
 check_outputs(1'b1, 4'd9);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            load = 1;
            preset = 4'd9;
            @(posedge clk_cin);
            #1 load = 0;
            EN = 1;
            @(posedge clk_cin);
            #1 #1;
 check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            EN = 1;
            repeat(4) @(posedge clk_cin);
            #1 #1;
 check_outputs(1'b0, 4'd4);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            preset = 4'd7;
            load = 1;
            EN = 1;
            @(posedge clk_cin);
            #1 load = 0;
            #1;

            check_outputs(1'b0, 4'd7);
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
        input expected_cout;
        input [3:0] expected_out;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, out=%h",
                         cout, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, out=%h",
                         expected_cout, expected_out);
                $display("  Got:      cout=%b, out=%h",
                         cout, out);
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
        $dumpvars(0,EN, clk_cin, load, preset, rst, cout, out);
    end

endmodule
