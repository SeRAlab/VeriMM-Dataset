`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg Clk;
    reg onCollision_obXL;
    reg [9:0] x;
    reg [9:0] y;
    wire [7:0] blue;
    wire [7:0] green;
    wire [1:0] obXLOn;
    wire [7:0] red;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Clk(Clk),
        .onCollision_obXL(onCollision_obXL),
        .x(x),
        .y(y),
        .blue(blue),
        .green(green),
        .obXLOn(obXLOn),
        .red(red)
    );

    // Clock generation (10ns period)
    initial begin
        Clk = 0;
        forever #5 Clk = ~Clk;
    end

        task reset_dut;

        begin
            onCollision_obXL = 0;
            x = 0;
            y = 0;
            repeat(2) @(posedge Clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Outside Bounds");
            reset_dut();
            x = 10'd0;
            y = 10'd0;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 2'b00, 8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Inside Bounds (Rendering)");
            reset_dut();
            x = 10'd300;
            y = 10'd200;
            @(posedge Clk);
            #1;




            if (blue == 8'hFF && obXLOn != 2'b00) begin
                 pass_count = pass_count + 1;
                 $display("PASS: Obstacle rendered blue at (300, 200)");
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: Obstacle not rendered as expected at (300, 200)");
            end
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Collision Trigger");
            reset_dut();
            x = 10'd300;
            y = 10'd200;
            @(posedge Clk);
            #1;

            onCollision_obXL = 1;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 2'b00, 8'h00);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Persistence after Collision");
            reset_dut();
            x = 10'd300;
            y = 10'd200;
            onCollision_obXL = 1;
            @(posedge Clk);
            #1;
            onCollision_obXL = 0;
            @(posedge Clk);
            #1;

            #1;


            check_outputs(8'h00, 8'h00, 2'b00, 8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Boundary Check (Alternate Point)");
            reset_dut();

            x = 10'd310;
            y = 10'd210;
            @(posedge Clk);
            #1;
            if (blue == 8'hFF && obXLOn != 2'b00) begin
                 pass_count = pass_count + 1;
                 $display("PASS: Obstacle rendered blue at (310, 210)");
            end else begin
                 fail_count = fail_count + 1;
                 $display("FAIL: Obstacle not rendered at (310, 210)");
            end
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
        input [7:0] expected_blue;
        input [7:0] expected_green;
        input [1:0] expected_obXLOn;
        input [7:0] expected_red;
        begin
            if (expected_blue === (expected_blue ^ blue ^ expected_blue) &&
                expected_green === (expected_green ^ green ^ expected_green) &&
                expected_obXLOn === (expected_obXLOn ^ obXLOn ^ expected_obXLOn) &&
                expected_red === (expected_red ^ red ^ expected_red)) begin
                $display("PASS");
                $display("  Outputs: blue=%h, green=%h, obXLOn=%h, red=%h",
                         blue, green, obXLOn, red);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: blue=%h, green=%h, obXLOn=%h, red=%h",
                         expected_blue, expected_green, expected_obXLOn, expected_red);
                $display("  Got:      blue=%h, green=%h, obXLOn=%h, red=%h",
                         blue, green, obXLOn, red);
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
        $dumpvars(0,Clk, onCollision_obXL, x, y, blue, green, obXLOn, red);
    end

endmodule
