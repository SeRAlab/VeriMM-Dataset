`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg clk;
    reg reset;
    wire cout;
    wire [3:0] sum;

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
        .reset(reset),
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
            @(negedge clk);
            reset = 1;
            a = 0;
            b = 0;
            cin = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: 2 + 3 + 0...");
            reset_dut();
            a = 4'h2;
            b = 4'h3;
            cin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h5);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: 8 + 4 + 1...");
            reset_dut();
            a = 4'h8;
            b = 4'h4;
            cin = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'hD);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: 15 + 1 + 0...");
            reset_dut();
            a = 4'hF;
            b = 4'h1;
            cin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: 15 + 15 + 1...");
            reset_dut();
            a = 4'hF;
            b = 4'hF;
            cin = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'hF);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: 0 + 0 + 0...");
            reset_dut();
            a = 4'h0;
            b = 4'h0;
            cin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'h0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: 5 + 10 + 0...");
            reset_dut();
            a = 4'b0101;
            b = 4'b1010;
            cin = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: 7 + 8 + 1...");
            reset_dut();
            a = 4'h7;
            b = 4'h8;
            cin = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1, 4'h0);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: Reset Verification...");

            a = 4'hF; b = 4'hF; cin = 1;
            @(posedge clk);
            #2;

            @(negedge clk);
            reset = 1;
            @(posedge clk);
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
        input expected_cout;
        input [3:0] expected_sum;
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
        $dumpvars(0,a, b, cin, clk, reset, cout, sum);
    end

endmodule
