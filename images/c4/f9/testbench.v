`timescale 1ns/1ps

module BinaryExponentiation_tb;

    // Testbench signals (sequential circuit)
    reg [8:0] base;
    reg clk;
    reg [7:0] exponent;
    reg reset;
    wire isDone;
    wire [99:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BinaryExponentiation dut (
        .base(base),
        .clk(clk),
        .exponent(exponent),
        .reset(reset),
        .isDone(isDone),
        .result(result)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            base = 0;
            exponent = 0;
            repeat(2) @(posedge clk);
            #1 reset = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: base=2, exponent=25", test_num);
            reset_dut();

            base = 2;
            exponent = 25;


            wait(isDone === 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 100'h0000000000000000002000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: base=3, exponent=17", test_num);
            reset_dut();

            base = 3;
            exponent = 17;

            wait(isDone === 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 100'h0000000000000000007B285C3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: base=5, exponent=30", test_num);
            reset_dut();

            base = 5;
            exponent = 30;

            wait(isDone === 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 100'h0000003270B2C3A2DD861A469);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: base=11, exponent=1", test_num);
            reset_dut();

            base = 11;
            exponent = 1;

            wait(isDone === 1'b1);
            @(posedge clk);
            #1;

            check_outputs(1'b1, 100'h000000000000000000000000B);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BinaryExponentiation Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        
        
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
        input expected_isDone;
        input [99:0] expected_result;
        begin
            if (expected_isDone === (expected_isDone ^ isDone ^ expected_isDone) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: isDone=%b, result=%h",
                         isDone, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: isDone=%b, result=%h",
                         expected_isDone, expected_result);
                $display("  Got:      isDone=%b, result=%h",
                         isDone, result);
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
        $dumpvars(0,base, clk, exponent, reset, isDone, result);
    end

endmodule
