`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg c1;
    reg c3;
    reg clk28m;
    reg [15:0] data_in;
    reg hires;
    reg load;
    reg [3:0] scroll;
    reg shres;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .c1(c1),
        .c3(c3),
        .clk28m(clk28m),
        .data_in(data_in),
        .hires(hires),
        .load(load),
        .scroll(scroll),
        .shres(shres),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk28m = 0;
        forever #5 clk28m = ~clk28m;
    end

        task reset_dut;

        begin
            c1 = 0;
            c3 = 0;
            data_in = 16'h0000;
            hires = 0;
            load = 0;
            scroll = 4'h0;
            shres = 0;
            repeat(4) @(posedge clk28m);
        end
        endtask
    task cycle_bus;

        begin
            @(posedge clk28m);
            c1 <= 0; c3 <= 0;
            @(posedge clk28m);
            c1 <= 1; c3 <= 0;
            @(posedge clk28m);
            c1 <= 1; c3 <= 1;
            @(posedge clk28m);
            c1 <= 0; c3 <= 1;
        end
        endtask

    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Basic Lores Load (Data=0x8000, Scroll=0)", test_num);

            data_in <= 16'h8000;
            scroll <= 4'd0;
            hires <= 0;
            shres <= 0;


            load <= 1;
            cycle_bus();
            load <= 0;


            repeat(2) @(posedge clk28m);

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Test %0d: Basic Lores Load (Data=0x0000, Scroll=0)", test_num);

            data_in <= 16'h0000;
            scroll <= 4'd0;

            load <= 1;
            cycle_bus();
            load <= 0;

            repeat(2) @(posedge clk28m);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Test %0d: Scroll Test (Data=0x4000, Scroll=1)", test_num);

            data_in <= 16'h4000;
            scroll <= 4'd1;
            hires <= 0;
            shres <= 0;

            load <= 1;
            cycle_bus();
            load <= 0;

            repeat(2) @(posedge clk28m);

            #1;


            check_outputs(out);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Hires Mode Check (Data=0xFFFF)", test_num);

            hires <= 1;
            shres <= 0;
            data_in <= 16'hFFFF;
            scroll <= 4'd0;

            load <= 1;
            cycle_bus();
            load <= 0;

            repeat(2) @(posedge clk28m);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Super Hires Mode Check (Data=0x0000)", test_num);

            hires <= 0;
            shres <= 1;
            data_in <= 16'h0000;

            load <= 1;
            cycle_bus();
            load <= 0;

            repeat(2) @(posedge clk28m);
            #1;

            check_outputs(1'b0);
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
        input expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
                         out);
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
        $dumpvars(0,c1, c3, clk28m, data_in, hires, load, scroll, shres, out);
    end

endmodule
