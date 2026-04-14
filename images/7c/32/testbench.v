`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg cin;
    reg clk;
    reg [3:0] num1;
    reg [3:0] num2;
    reg reset;
    wire cout;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .cin(cin),
        .clk(clk),
        .num1(num1),
        .num2(num2),
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
            reset = 1;
            num1 = 0;
            num2 = 0;
            cin = 0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'd3;
            num2 <= 4'd4;
            cin  <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: 3 + 4, cin=0", test_num);
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'd5;
            num2 <= 4'd5;
            cin  <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: 5 + 5, cin=1", test_num);
            #1;

            check_outputs(1'b0, 4'd11);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'd10;
            num2 <= 4'd10;
            cin  <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: 10 + 10, cin=0", test_num);
            #1;

            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'hf;
            num2 <= 4'hf;
            cin  <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: 15 + 15, cin=1", test_num);
            #1;

            check_outputs(1'b1, 4'hf);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'd0;
            num2 <= 4'd0;
            cin  <= 1'b0;
            @(posedge clk);
            #2;
            $display("Test %0d: 0 + 0, cin=0", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'd15;
            num2 <= 4'd0;
            cin  <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: 15 + 0, cin=1", test_num);
            #1;

            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            reset_dut();
            @(posedge clk);
            num1 <= 4'd8;
            num2 <= 4'd8;
            cin  <= 1'b0;
            reset <= 1'b1;
            @(posedge clk);
            #2;
            $display("Test %0d: Reset behavior check", test_num);
            #1;

            check_outputs(1'b0, 4'd0);
            reset <= 1'b0;
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
        $dumpvars(0,cin, clk, num1, num2, reset, cout, sum);
    end

endmodule
