`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [9:0] pbot;
    reg [9:0] ptop;
    reg [9:0] x;
    reg [9:0] y;
    wire scan;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .pbot(pbot),
        .ptop(ptop),
        .x(x),
        .y(y),
        .scan(scan)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            ptop <= 0;
            pbot <= 0;
            x <= 0;
            y <= 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Coordinate y in middle of range", test_num);
            ptop <= 10'd100;
            pbot <= 10'd200;
            y <= 10'd150;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Coordinate y above range", test_num);
            ptop <= 10'd100;
            pbot <= 10'd200;
            y <= 10'd50;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Coordinate y below range", test_num);
            ptop <= 10'd100;
            pbot <= 10'd200;
            y <= 10'd250;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Coordinate y at ptop boundary", test_num);
            ptop <= 10'd100;
            pbot <= 10'd200;
            y <= 10'd100;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Coordinate y at pbot boundary", test_num);
            ptop <= 10'd100;
            pbot <= 10'd200;
            y <= 10'd200;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Paddle at origin (y=0)", test_num);
            ptop <= 10'd0;
            pbot <= 10'd50;
            y <= 10'd0;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Test %0d: Inverted range (ptop > pbot)", test_num);
            ptop <= 10'd200;
            pbot <= 10'd100;
            y <= 10'd150;
            x <= 10'd0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(1'b0);
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
        input expected_scan;
        begin
            if (expected_scan === (expected_scan ^ scan ^ expected_scan)) begin
                $display("PASS");
                $display("  Outputs: scan=%b",
                         scan);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: scan=%b",
                         expected_scan);
                $display("  Got:      scan=%b",
                         scan);
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
        $dumpvars(0,clk, pbot, ptop, x, y, scan);
    end

endmodule
