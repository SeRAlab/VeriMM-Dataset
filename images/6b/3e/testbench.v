`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg load;
    reg [3:0] load_value;
    reg reset;
    wire carry;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .carry(carry),
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
            load = 0;
            load_value = 4'b0;
            #15;
            reset = 0;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 4'h5;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            @(posedge clk);
            load = 1;
            load_value = 4'h9;
            @(posedge clk);
            #1;
            load = 0;

            #1;


            check_outputs(1'b1, 4'h9);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            load = 1;
            load_value = 4'h9;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();

            repeat(3) @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 4'h3);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            load = 1;
            load_value = 4'h7;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 4'h8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            load = 1;
            load_value = 4'h8;
            @(posedge clk);
            #1;
            load = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 4'h9);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            load = 1;
            load_value = 4'hA;
            @(posedge clk);
            #1;
            reset = 1;
            #2;
            #1;

            check_outputs(1'b0, 4'h0);
            reset = 0;
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
        input expected_carry;
        input [3:0] expected_q;
        begin
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: carry=%b, q=%h",
                         carry, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%b, q=%h",
                         expected_carry, expected_q);
                $display("  Got:      carry=%b, q=%h",
                         carry, q);
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
        $dumpvars(0,clk, load, load_value, reset, carry, q);
    end

endmodule
