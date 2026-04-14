`timescale 1ns/1ps

module rc_oscillator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] C;
    reg [7:0] R;
    reg clk;
    reg reset;
    wire clk_div2;
    wire clk_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    rc_oscillator dut (
        .C(C),
        .R(R),
        .clk(clk),
        .reset(reset),
        .clk_div2(clk_div2),
        .clk_out(clk_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        reset = 1;
        R = 0;
        C = 0;
        #20;
        reset = 0;
        #10;
    end
        endtask
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Fast Oscillation (Small R, C)", test_num);
        reset_dut();



        R = 8'd2;
        C = 8'd5;


        #400;



        #1;




        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Slow Oscillation (Large R, C)", test_num);
        reset_dut();


        R = 8'd20;
        C = 8'd20;


        #2000;


        #1;



        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Dynamic Frequency Change", test_num);
        reset_dut();

        R = 8'd10;
        C = 8'd5;
        #500;


        R = 8'd5;
        C = 8'd2;
        #300;

        #1;


        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Reset Behavior during Oscillation", test_num);
        reset_dut();

        R = 8'd4;
        C = 8'd4;
        #100;

        reset = 1;
        #50;


        #1;



        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %03d: Minimum R and C values", test_num);
        reset_dut();

        R = 8'd1;
        C = 8'd1;

        #100;

        #1;


        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("rc_oscillator Testbench");
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
        input expected_clk_div2;
        input expected_clk_out;
        begin
            if (expected_clk_div2 === (expected_clk_div2 ^ clk_div2 ^ expected_clk_div2) &&
                expected_clk_out === (expected_clk_out ^ clk_out ^ expected_clk_out)) begin
                $display("PASS");
                $display("  Outputs: clk_div2=%b, clk_out=%b",
                         clk_div2, clk_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clk_div2=%b, clk_out=%b",
                         expected_clk_div2, expected_clk_out);
                $display("  Got:      clk_div2=%b, clk_out=%b",
                         clk_div2, clk_out);
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
        $dumpvars(0,C, R, clk, reset, clk_div2, clk_out);
    end

endmodule
