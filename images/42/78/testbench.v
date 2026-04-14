`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [1:0] a;
    reg [1:0] b;
    reg cin;
    reg clk;
    wire cout;
    wire [1:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .cin(cin),
        .clk(clk),
        .cout(cout),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a <= 0;
            b <= 0;
            cin <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: 0 + 0 + 0");
            reset_dut();
            a <= 2'b00;
            b <= 2'b00;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b00);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: 1 + 1 + 0");
            reset_dut();
            a <= 2'b01;
            b <= 2'b01;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b10);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: 1 + 1 + 1");
            reset_dut();
            a <= 2'b01;
            b <= 2'b01;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b11);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: 2 + 2 + 0");
            reset_dut();
            a <= 2'b10;
            b <= 2'b10;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: 3 + 3 + 1");
            reset_dut();
            a <= 2'b11;
            b <= 2'b11;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b11);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: 3 + 1 + 0");
            reset_dut();
            a <= 2'b11;
            b <= 2'b01;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: 0 + 0 + 1");
            reset_dut();
            a <= 2'b00;
            b <= 2'b00;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 2'b01);
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: 2 + 1 + 1");
            reset_dut();
            a <= 2'b10;
            b <= 2'b01;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase009;

        begin
            $display("Testcase 009: 3 + 0 + 1");
            reset_dut();
            a <= 2'b11;
            b <= 2'b00;
            cin <= 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b00);
        end
        endtask

    task testcase010;

        begin
            $display("Testcase 010: 2 + 3 + 0");
            reset_dut();
            a <= 2'b10;
            b <= 2'b11;
            cin <= 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 2'b01);
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
        input expected_cout;
        input [1:0] expected_sum;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, sum=%h",
                         cout, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, sum=%h",
                         expected_cout, expected_sum);
                $display("  Got:      cout=%b, sum=%h",
                         cout, sum);
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
        $dumpvars(0,a, b, cin, clk, cout, sum);
    end

endmodule
