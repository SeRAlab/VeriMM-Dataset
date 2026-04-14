`timescale 1ns/1ps

module DWT_Haar_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg start;
    reg [3:0] x;
    wire [3:0] approximation;
    wire [3:0] detail;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DWT_Haar dut (
        .clk(clk),
        .start(start),
        .x(x),
        .approximation(approximation),
        .detail(detail),
        .valid(valid)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start = 0;
            x = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Running Testcase %0d: Positive Difference (10, 2)", test_num);
            @(posedge clk);
            x = 4'd10; start = 1;
            @(posedge clk);
            x = 4'd2;
            @(posedge clk);
            start = 0;
            #1;

            check_outputs(4'd6, 4'd4, 1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Running Testcase %0d: Negative Difference (4, 12)", test_num);
            @(posedge clk);
            x = 4'd4; start = 1;
            @(posedge clk);
            x = 4'd12;
            @(posedge clk);
            start = 0;
            #1;

            check_outputs(4'd8, 4'hC, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Running Testcase %0d: Max Values (15, 15)", test_num);
            @(posedge clk);
            x = 4'd15; start = 1;
            @(posedge clk);
            x = 4'd15;
            @(posedge clk);
            start = 0;
            #1;

            check_outputs(4'd15, 4'd0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Running Testcase %0d: Min Values (0, 0)", test_num);
            @(posedge clk);
            x = 4'd0; start = 1;
            @(posedge clk);
            x = 4'd0;
            @(posedge clk);
            start = 0;
            #1;

            check_outputs(4'd0, 4'd0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Running Testcase %0d: Odd Sum Truncation (15, 0)", test_num);
            @(posedge clk);
            x = 4'd15; start = 1;
            @(posedge clk);
            x = 4'd0;
            @(posedge clk);
            start = 0;
            #1;

            check_outputs(4'd7, 4'd7, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DWT_Haar Testbench");
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
        input [3:0] expected_approximation;
        input [3:0] expected_detail;
        input expected_valid;
        begin
            if (expected_approximation === (expected_approximation ^ approximation ^ expected_approximation) &&
                expected_detail === (expected_detail ^ detail ^ expected_detail) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: approximation=%h, detail=%h, valid=%b",
                         approximation, detail, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: approximation=%h, detail=%h, valid=%b",
                         expected_approximation, expected_detail, expected_valid);
                $display("  Got:      approximation=%h, detail=%h, valid=%b",
                         approximation, detail, valid);
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
        $dumpvars(0,clk, start, x, approximation, detail, valid);
    end

endmodule
