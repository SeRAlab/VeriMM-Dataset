`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg LOCKED;
    reg clk;
    reg [31:0] desired_shift_1000;
    reg rst;
    wire fail;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .LOCKED(LOCKED),
        .clk(clk),
        .desired_shift_1000(desired_shift_1000),
        .rst(rst),
        .fail(fail)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            LOCKED = 0;
            desired_shift_1000 = 0;
            repeat(2) @(posedge clk);
            #1;
            rst = 0;
            repeat(1) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            LOCKED = 1;
            desired_shift_1000 = 32'd250;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            LOCKED = 1;
            desired_shift_1000 = -32'd500;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            LOCKED = 1;
            desired_shift_1000 = 32'd0;
            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            LOCKED = 0;
            desired_shift_1000 = 32'd250;
            repeat(5) @(posedge clk);

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            LOCKED = 1;
            desired_shift_1000 = 32'd5000;
            repeat(10) @(posedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            reset_dut();
            LOCKED = 1;
            desired_shift_1000 = -32'd2000;
            repeat(10) @(posedge clk);
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
        input expected_fail;
        begin
            if (expected_fail === (expected_fail ^ fail ^ expected_fail)) begin
                $display("PASS");
                $display("  Outputs: fail=%b",
                         fail);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: fail=%b",
                         expected_fail);
                $display("  Got:      fail=%b",
                         fail);
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
        $dumpvars(0,LOCKED, clk, desired_shift_1000, rst, fail);
    end

endmodule
