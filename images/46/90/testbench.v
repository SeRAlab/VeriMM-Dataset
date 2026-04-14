`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg d;
    reg [10:0] poX;
    reg [10:0] poY;
    reg rst;
    reg timer;
    reg trigger;
    reg [10:0] x;
    reg [10:0] y;
    wire bullet;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .d(d),
        .poX(poX),
        .poY(poY),
        .rst(rst),
        .timer(timer),
        .trigger(trigger),
        .x(x),
        .y(y),
        .bullet(bullet)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            trigger = 0;
            timer = 0;
            d = 0;
            poX = 0;
            poY = 0;
            x = 0;
            y = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            x = 100;
            y = 100;
            @(posedge clk);
            $display("Testcase %0d: Bullet inactive after reset", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            poX = 11'd500;
            poY = 11'd400;
            x = 11'd500;
            y = 11'd400;
            trigger = 1;
            @(posedge clk);
            trigger = 0;
            @(posedge clk);
            $display("Testcase %0d: Bullet appearance at trigger position", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            poX = 11'd100;
            poY = 11'd100;
            d = 0;
            trigger = 1;
            @(posedge clk);
            trigger = 0;


            repeat(5) begin
                timer = 1;
                @(posedge clk);
                timer = 0;
                @(posedge clk);
            end



            x = 11'd100;
            y = 11'd95;

            @(posedge clk);
            $display("Testcase %0d: Bullet movement upward (d=0)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            poX = 11'd200;
            poY = 11'd200;
            d = 1;
            trigger = 1;
            @(posedge clk);
            trigger = 0;


            repeat(10) begin
                timer = 1;
                @(posedge clk);
                timer = 0;
                @(posedge clk);
            end


            x = 11'd200;
            y = 11'd210;

            @(posedge clk);
            $display("Testcase %0d: Bullet movement downward (d=1)", test_num);
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            poX = 11'd300;
            poY = 11'd300;
            trigger = 1;
            @(posedge clk);
            trigger = 0;


            x = 11'd350;
            y = 11'd350;

            @(posedge clk);
            $display("Testcase %0d: Bullet not visible at non-matching coordinates", test_num);
            #1;

            check_outputs(0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            poX = 11'd150;
            poY = 11'd150;
            trigger = 1;
            @(posedge clk);
            trigger = 0;

            timer = 1; @(posedge clk); timer = 0; @(posedge clk);


            x = 11'd150; y = 11'd149;


            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);

            $display("Testcase %0d: Bullet cleared after middle-of-flight reset", test_num);
            #1;

            check_outputs(0);
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
        input expected_bullet;
        begin
            if (expected_bullet === (expected_bullet ^ bullet ^ expected_bullet)) begin
                $display("PASS");
                $display("  Outputs: bullet=%b",
                         bullet);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bullet=%b",
                         expected_bullet);
                $display("  Got:      bullet=%b",
                         bullet);
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
        $dumpvars(0,clk, d, poX, poY, rst, timer, trigger, x, y, bullet);
    end

endmodule
