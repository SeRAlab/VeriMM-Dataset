`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg a;
    reg b;
    reg clk;
    reg load;
    reg [3:0] load_value;
    reg reset;
    wire out;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .clk(clk),
        .load(load),
        .load_value(load_value),
        .reset(reset),
        .out(out),
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
            load_value = 4'b0000;
            a = 0;
            b = 0;
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


            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            @(posedge clk);
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            load_value = 4'b0101;
            load = 1;
            @(posedge clk);
            #2;
            load = 0;

            #1;


            check_outputs(1'b0, 4'd5);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            reset_dut();
            load_value = 4'd15;
            load = 1;
            @(posedge clk);
            #2 load = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            reset_dut();

            for(i=0; i<8; i=i+1) begin
                @(posedge clk);
            end
            #2;
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            a = 1;
            b = 1;
            #2;

            #1;


            check_outputs(1'b1, 4'd8);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            a = 1;
            b = 0;
            #2;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            reset_dut();
            a = 0;
            b = 1;
            #2;
            #1;

            check_outputs(1'b0, 4'd8);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            reset_dut();
            @(posedge clk);
            load_value = 4'd12;
            load = 1;
            @(posedge clk);
            #2 load = 0;

            #1 reset = 1;
            #1;
            #1;

            check_outputs(1'b0, 4'd8);
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
        input expected_out;
        input [3:0] expected_q;
        begin
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: out=%b, q=%h",
                         out, q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b, q=%h",
                         expected_out, expected_q);
                $display("  Got:      out=%b, q=%h",
                         out, q);
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
        $dumpvars(0,a, b, clk, load, load_value, reset, out, q);
    end

endmodule
