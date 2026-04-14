`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg clk;
    wire [7:0] OUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .A(A),
        .B(B),
        .clk(clk),
        .OUT(OUT)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            A = 0;
            B = 0;

            repeat (10) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0 x 0", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd0;

            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1 x 1", test_num);
            reset_dut();
            A = 4'd1;
            B = 4'd1;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max values (15 x 15)", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd15;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd225);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 3 x 5", test_num);
            reset_dut();
            A = 4'd3;
            B = 4'd5;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 10 x 2", test_num);
            reset_dut();
            A = 4'd10;
            B = 4'd2;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero (7 x 0)", test_num);
            reset_dut();
            A = 4'd7;
            B = 4'd0;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiplication by zero (0 x 12)", test_num);
            reset_dut();
            A = 4'd0;
            B = 4'd12;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 9 x 9", test_num);
            reset_dut();
            A = 4'd9;
            B = 4'd9;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd81);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Power of 2 (4 x 4)", test_num);
            reset_dut();
            A = 4'd4;
            B = 4'd4;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd16);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 15 x 1", test_num);
            reset_dut();
            A = 4'd15;
            B = 4'd1;
            repeat (8) @(posedge clk);
            #1;

            check_outputs(8'd15);
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
        input [7:0] expected_OUT;
        begin
            if (expected_OUT === (expected_OUT ^ OUT ^ expected_OUT)) begin
                $display("PASS");
                $display("  Outputs: OUT=%h",
                         OUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: OUT=%h",
                         expected_OUT);
                $display("  Got:      OUT=%h",
                         OUT);
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
        $dumpvars(0,A, B, clk, OUT);
    end

endmodule
