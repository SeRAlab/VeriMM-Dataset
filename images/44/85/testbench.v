`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] data_in;
    reg enable;
    reg load;
    reg reset;
    wire carry_out;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .data_in(data_in),
        .enable(enable),
        .load(load),
        .reset(reset),
        .carry_out(carry_out),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            load = 0;
            enable = 0;
            data_in = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Enable counting for 5 cycles", test_num);
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load value 4'hA", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'hA;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b0, 4'hA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Verify enable control (stalling)", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'h5;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Max count and Carry-out", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Roll-over from 15 to 0", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'hF;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Reset priority over Load", test_num);
            reset_dut();
            @(posedge clk);
            reset = 1;
            load = 1;
            data_in = 4'hC;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Load priority over Enable (Increment)", test_num);
            reset_dut();
            @(posedge clk);
            load = 1;
            enable = 1;
            data_in = 4'h7;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h7);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Transition to Carry-out via increment", test_num);
            reset_dut();
            @(posedge clk);
            data_in = 4'hE;
            load = 1;
            @(posedge clk);
            #1 load = 0;
            enable = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'hF);
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
        input expected_carry_out;
        input [3:0] expected_count;
        begin
            if (expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out) &&
                expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: carry_out=%b, count=%h",
                         carry_out, count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_out=%b, count=%h",
                         expected_carry_out, expected_count);
                $display("  Got:      carry_out=%b, count=%h",
                         carry_out, count);
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
        $dumpvars(0,clk, data_in, enable, load, reset, carry_out, count);
    end

endmodule
