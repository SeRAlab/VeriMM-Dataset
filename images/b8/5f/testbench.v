`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] btn;
    reg clk;
    reg reset_n;
    reg [3:0] sw;
    wire led0_b;
    wire led0_g;
    wire led0_r;
    wire led1_b;
    wire led1_g;
    wire led1_r;
    wire led2_b;
    wire led2_g;
    wire led2_r;
    wire led3_b;
    wire led3_g;
    wire led3_r;
    wire led4;
    wire led5;
    wire led6;
    wire led7;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .btn(btn),
        .clk(clk),
        .reset_n(reset_n),
        .sw(sw),
        .led0_b(led0_b),
        .led0_g(led0_g),
        .led0_r(led0_r),
        .led1_b(led1_b),
        .led1_g(led1_g),
        .led1_r(led1_r),
        .led2_b(led2_b),
        .led2_g(led2_g),
        .led2_r(led2_r),
        .led3_b(led3_b),
        .led3_g(led3_g),
        .led3_r(led3_r),
        .led4(led4),
        .led5(led5),
        .led6(led6),
        .led7(led7)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset_n = 0;
            btn = 4'b0;
            sw = 4'b0;
            @(posedge clk);
            #2 reset_n = 1;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(0,0,0, 0,0,0, 0,0,0, 0,0,0, 0,0,0,0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            sw = 4'b1010;
            btn = 4'b0001;
            @(posedge clk);
            #2;



            #1;




            check_outputs(0,1,0, 1,0,1, 0,1,0, 1,0,1, 0,1,0,1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            sw = 4'b1111;
            btn = 4'b0001;
            @(posedge clk);
            #2 btn = 4'b0000;
            sw = 4'b0000;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1,1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            sw = 4'b0101;
            btn = 4'b0010;
            @(posedge clk);
            #2;

            #1;


            check_outputs(1,0,1, 0,1,0, 1,0,1, 0,1,0, 1,0,1,0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            sw = 4'b1111;
            btn = 4'b1000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1,1,1, 1,1,1, 1,1,1, 1,1,1, 1,1,1,1);
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
        input expected_led0_b;
        input expected_led0_g;
        input expected_led0_r;
        input expected_led1_b;
        input expected_led1_g;
        input expected_led1_r;
        input expected_led2_b;
        input expected_led2_g;
        input expected_led2_r;
        input expected_led3_b;
        input expected_led3_g;
        input expected_led3_r;
        input expected_led4;
        input expected_led5;
        input expected_led6;
        input expected_led7;
        begin
            if (expected_led0_b === (expected_led0_b ^ led0_b ^ expected_led0_b) &&
                expected_led0_g === (expected_led0_g ^ led0_g ^ expected_led0_g) &&
                expected_led0_r === (expected_led0_r ^ led0_r ^ expected_led0_r) &&
                expected_led1_b === (expected_led1_b ^ led1_b ^ expected_led1_b) &&
                expected_led1_g === (expected_led1_g ^ led1_g ^ expected_led1_g) &&
                expected_led1_r === (expected_led1_r ^ led1_r ^ expected_led1_r) &&
                expected_led2_b === (expected_led2_b ^ led2_b ^ expected_led2_b) &&
                expected_led2_g === (expected_led2_g ^ led2_g ^ expected_led2_g) &&
                expected_led2_r === (expected_led2_r ^ led2_r ^ expected_led2_r) &&
                expected_led3_b === (expected_led3_b ^ led3_b ^ expected_led3_b) &&
                expected_led3_g === (expected_led3_g ^ led3_g ^ expected_led3_g) &&
                expected_led3_r === (expected_led3_r ^ led3_r ^ expected_led3_r) &&
                expected_led4 === (expected_led4 ^ led4 ^ expected_led4) &&
                expected_led5 === (expected_led5 ^ led5 ^ expected_led5) &&
                expected_led6 === (expected_led6 ^ led6 ^ expected_led6) &&
                expected_led7 === (expected_led7 ^ led7 ^ expected_led7)) begin
                $display("PASS");
                $display("  Outputs: led0_b=%b, led0_g=%b, led0_r=%b, led1_b=%b, led1_g=%b, led1_r=%b, led2_b=%b, led2_g=%b, led2_r=%b, led3_b=%b, led3_g=%b, led3_r=%b, led4=%b, led5=%b, led6=%b, led7=%b",
                         led0_b, led0_g, led0_r, led1_b, led1_g, led1_r, led2_b, led2_g, led2_r, led3_b, led3_g, led3_r, led4, led5, led6, led7);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led0_b=%b, led0_g=%b, led0_r=%b, led1_b=%b, led1_g=%b, led1_r=%b, led2_b=%b, led2_g=%b, led2_r=%b, led3_b=%b, led3_g=%b, led3_r=%b, led4=%b, led5=%b, led6=%b, led7=%b",
                         expected_led0_b, expected_led0_g, expected_led0_r, expected_led1_b, expected_led1_g, expected_led1_r, expected_led2_b, expected_led2_g, expected_led2_r, expected_led3_b, expected_led3_g, expected_led3_r, expected_led4, expected_led5, expected_led6, expected_led7);
                $display("  Got:      led0_b=%b, led0_g=%b, led0_r=%b, led1_b=%b, led1_g=%b, led1_r=%b, led2_b=%b, led2_g=%b, led2_r=%b, led3_b=%b, led3_g=%b, led3_r=%b, led4=%b, led5=%b, led6=%b, led7=%b",
                         led0_b, led0_g, led0_r, led1_b, led1_g, led1_r, led2_b, led2_g, led2_r, led3_b, led3_g, led3_r, led4, led5, led6, led7);
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
        $dumpvars(0,btn, clk, reset_n, sw, led0_b, led0_g, led0_r, led1_b, led1_g, led1_r, led2_b, led2_g, led2_r, led3_b, led3_g, led3_r, led4, led5, led6, led7);
    end

endmodule
