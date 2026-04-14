`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] in;
    reg load;
    reg rst;
    reg up_down;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .in(in),
        .load(load),
        .rst(rst),
        .up_down(up_down),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            load = 0;
            up_down = 0;
            in = 4'b0000;
            @(posedge clk);
            #1 rst = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset Check", test_num);
            reset_dut();

            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Load Parallel Value Check", test_num);
            reset_dut();
            in = 4'hA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Count Up Check (0 to 3)", test_num);
            reset_dut();
            up_down = 1;
            repeat(3) @(posedge clk);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Count Down Check (5 to 3)", test_num);
            reset_dut();
            in = 4'h5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            up_down = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Rollover Check (15 to 0)", test_num);
            reset_dut();
            in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Rollunder Check (0 to 15)", test_num);
            reset_dut();
            up_down = 0;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %03d: Load priority over counting", test_num);
            reset_dut();
            in = 4'hC;
            load = 1;
            up_down = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'hC);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %03d: Reset priority over Load", test_num);
            reset_dut();
            in = 4'hE;
            load = 1;
            rst = 1;
            @(posedge clk);
            #1 #1;
 check_outputs(4'h0);
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
        input [3:0] expected_out;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
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
        $dumpvars(0,clk, in, load, rst, up_down, out);
    end

endmodule
