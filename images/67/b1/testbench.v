`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg evaluateCollision;
    reg [7:0] height;
    reg resetLow;
    reg [4:0] width;
    reg [7:0] xBird;
    reg [7:0] xPipe;
    reg [6:0] yBird;
    reg [6:0] yPipe;
    wire collisionHappen;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .evaluateCollision(evaluateCollision),
        .height(height),
        .resetLow(resetLow),
        .width(width),
        .xBird(xBird),
        .xPipe(xPipe),
        .yBird(yBird),
        .yPipe(yPipe),
        .collisionHappen(collisionHappen)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            resetLow = 0;
            evaluateCollision = 0;
            xBird = 0;
            yBird = 0;
            xPipe = 0;
            yPipe = 0;
            height = 0;
            width = 0;
            @(posedge clk);
            #1;
            resetLow = 1;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            xBird = 8'd200; yBird = 7'd100;
            xPipe = 8'd10;  yPipe = 7'd10;
            width = 5'd15;  height = 8'd20;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            xPipe = 8'd50;  yPipe = 7'd30;
            width = 5'd10;  height = 8'd40;
            xBird = 8'd50;  yBird = 7'd30;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            xPipe = 8'd50;  yPipe = 7'd30;
            width = 5'd10;  height = 8'd40;
            xBird = 8'd60;  yBird = 7'd70;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            xPipe = 8'd100; yPipe = 7'd50;
            width = 5'd20;  height = 8'd30;
            xBird = 8'd110; yBird = 7'd65;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            xPipe = 8'd100; yPipe = 7'd50;
            width = 5'd20;  height = 8'd30;
            xBird = 8'd110; yBird = 7'd65;
            evaluateCollision = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            xPipe = 8'd100; yPipe = 7'd50;
            width = 5'd20;  height = 8'd30;
            xBird = 8'd99;  yBird = 7'd65;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            xPipe = 8'd100; yPipe = 7'd50;
            width = 5'd20;  height = 8'd30;
            xBird = 8'd121; yBird = 7'd65;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            xPipe = 8'd100; yPipe = 7'd50;
            width = 5'd20;  height = 8'd30;
            xBird = 8'd110; yBird = 7'd49;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            reset_dut();
            test_num = 9;
            xPipe = 8'd100; yPipe = 7'd50;
            width = 5'd20;  height = 8'd30;
            xBird = 8'd110; yBird = 7'd81;
            evaluateCollision = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            reset_dut();
            test_num = 10;

            xPipe = 8'd50;  yPipe = 7'd30;
            width = 5'd10;  height = 8'd10;
            xBird = 8'd55;  yBird = 7'd35;
            evaluateCollision = 1;
            @(posedge clk);
            #1;

            xBird = 8'd0; yBird = 8'd0;
            evaluateCollision = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(1'b1);
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
        input expected_collisionHappen;
        begin
            if (expected_collisionHappen === (expected_collisionHappen ^ collisionHappen ^ expected_collisionHappen)) begin
                $display("PASS");
                $display("  Outputs: collisionHappen=%b",
                         collisionHappen);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: collisionHappen=%b",
                         expected_collisionHappen);
                $display("  Got:      collisionHappen=%b",
                         collisionHappen);
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
        $dumpvars(0,clk, evaluateCollision, height, resetLow, width, xBird, xPipe, yBird, yPipe, collisionHappen);
    end

endmodule
