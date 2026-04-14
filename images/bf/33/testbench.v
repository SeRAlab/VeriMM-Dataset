`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down_sync;
    reg [4:0] speed;
    reg start_barra;
    reg up_sync;
    wire [9:0] barra_y;
    wire bussy_barra;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .down_sync(down_sync),
        .speed(speed),
        .start_barra(start_barra),
        .up_sync(up_sync),
        .barra_y(barra_y),
        .bussy_barra(bussy_barra)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            start_barra = 0;
            up_sync = 0;
            down_sync = 0;
            speed = 5'd0;
            repeat(2) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            speed = 5'd10;
            down_sync = 1;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Idle State Check", test_num);

            #1;


            check_outputs(10'd200, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            speed = 5'd15;
            down_sync = 1;
            up_sync = 0;
            start_barra = 1;
            @(posedge clk);
            start_barra = 0;

            repeat(5) @(posedge clk);
            $display("Testcase %0d: Move Down (Speed 15)", test_num);
            #1;

            check_outputs(10'd215, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            speed = 5'd20;
            down_sync = 0;
            up_sync = 1;
            start_barra = 1;
            @(posedge clk);
            start_barra = 0;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Move Up (Speed 20)", test_num);
            #1;

            check_outputs(10'd180, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();

            speed = 5'd31;
            up_sync = 1;

            repeat(10) begin
                start_barra = 1;
                @(posedge clk);
                start_barra = 0;
                repeat(4) @(posedge clk);
            end
            $display("Testcase %0d: Upper Boundary Constraint", test_num);

            if (barra_y < 10'd100) begin
                pass_count = pass_count + 1;
                $display("PASS: Limited at %d", barra_y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Boundary failed, barra_y=%d", barra_y);
            end
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            speed = 5'd0;
            down_sync = 1;
            start_barra = 1;
            @(posedge clk);
            start_barra = 0;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Zero Speed Check", test_num);
            #1;

            check_outputs(10'd200, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            speed = 5'd10;
            up_sync = 1;
            down_sync = 1;
            start_barra = 1;
            @(posedge clk);
            start_barra = 0;
            repeat(5) @(posedge clk);
            $display("Testcase %0d: Concurrent Up/Down Sync", test_num);


            if (barra_y >= 190 && barra_y <= 210) begin
                pass_count = pass_count + 1;
                $display("PASS: Handled conflict, barra_y=%d", barra_y);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: barra_y unexpected value %d", barra_y);
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
        input [9:0] expected_barra_y;
        input expected_bussy_barra;
        begin
            if (expected_barra_y === (expected_barra_y ^ barra_y ^ expected_barra_y) &&
                expected_bussy_barra === (expected_bussy_barra ^ bussy_barra ^ expected_bussy_barra)) begin
                $display("PASS");
                $display("  Outputs: barra_y=%h, bussy_barra=%b",
                         barra_y, bussy_barra);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: barra_y=%h, bussy_barra=%b",
                         expected_barra_y, expected_bussy_barra);
                $display("  Got:      barra_y=%h, bussy_barra=%b",
                         barra_y, bussy_barra);
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
        $dumpvars(0,clk, down_sync, speed, start_barra, up_sync, barra_y, bussy_barra);
    end

endmodule
