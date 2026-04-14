`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg cin;
    reg clk;
    reg sub;
    wire cout;
    wire overflow;
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
        .sub(sub),
        .cout(cout),
        .overflow(overflow),
        .sum(sum)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            a = 0;
            b = 0;
            cin = 0;
            sub = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            a = 4'd2; b = 4'd3; sub = 1'b0; cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd5);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            a = 4'b0111; b = 4'b0001; sub = 1'b0; cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b1, 4'b1000);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            a = 4'b1111; b = 4'b0001; sub = 1'b0; cin = 1'b0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 1'b0, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            a = 4'd5; b = 4'd3; sub = 1'b1; cin = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 4'd2);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            a = 4'b1000; b = 4'b0001; sub = 1'b1; cin = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b1, 4'b0111);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            a = 4'd1; b = 4'd1; sub = 1'b0; cin = 1'b1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0, 1'b0, 4'd3);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            a = 4'd5; b = 4'd2; sub = 1'b1; cin = 1'b1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1, 1'b0, 4'd2);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            a = 4'd2; b = 4'd5; sub = 1'b1; cin = 1'b0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b0, 1'b0, 4'hD);
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
        input expected_overflow;
        input [3:0] expected_sum;
        begin
            if (expected_cout === (expected_cout ^ cout ^ expected_cout) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: cout=%b, overflow=%b, sum=%h",
                         cout, overflow, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: cout=%b, overflow=%b, sum=%h",
                         expected_cout, expected_overflow, expected_sum);
                $display("  Got:      cout=%b, overflow=%b, sum=%h",
                         cout, overflow, sum);
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
        $dumpvars(0,a, b, cin, clk, sub, cout, overflow, sum);
    end

endmodule
