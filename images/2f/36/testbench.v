`timescale 1ns/1ps

module i2c_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [7:0] data_in;
    reg rst;
    reg start;
    reg stop;
    wire busy;
    wire scl;
    wire sda;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    i2c_controller dut (
        .clk(clk),
        .data_in(data_in),
        .rst(rst),
        .start(start),
        .stop(stop),
        .busy(busy),
        .scl(scl),
        .sda(sda)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            data_in = 8'h00;
            start = 0;
            stop = 0;
            #20;
            rst = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTestcase %03d: Sending 0xA5 (Standard Data)", test_num);
            reset_dut();

            data_in = 8'hA5;
            start = 1;
            stop = 1;


            @(posedge clk);
            wait(busy == 1);
            start = 0;
            stop = 0;


            wait(busy == 0);
            #50;


            #1;



            check_outputs(0, 1, 1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTestcase %03d: Sending 0x00 (All Zeros)", test_num);
            reset_dut();

            data_in = 8'h00;
            start = 1;
            stop = 1;

            @(posedge clk);
            wait(busy == 1);
            start = 0;
            stop = 0;

            wait(busy == 0);
            #50;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTestcase %03d: Sending 0xFF (All Ones)", test_num);
            reset_dut();

            data_in = 8'hFF;
            start = 1;
            stop = 1;

            @(posedge clk);
            wait(busy == 1);
            start = 0;
            stop = 0;

            wait(busy == 0);
            #50;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTestcase %03d: Sending 0x55 (Alternating Bits)", test_num);
            reset_dut();

            data_in = 8'h55;
            start = 1;
            stop = 1;

            @(posedge clk);
            wait(busy == 1);
            start = 0;
            stop = 0;

            wait(busy == 0);
            #50;

            #1;


            check_outputs(0, 1, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTestcase %03d: Verify Post-Reset State", test_num);
            reset_dut();
            #20;


            #1;



            check_outputs(0, 1, 1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("i2c_controller Testbench");
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
        input expected_busy;
        input expected_scl;
        input expected_sda;
        begin
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_scl === (expected_scl ^ scl ^ expected_scl) &&
                expected_sda === (expected_sda ^ sda ^ expected_sda)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, scl=%b, sda=%b",
                         busy, scl, sda);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, scl=%b, sda=%b",
                         expected_busy, expected_scl, expected_sda);
                $display("  Got:      busy=%b, scl=%b, sda=%b",
                         busy, scl, sda);
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
        $dumpvars(0,clk, data_in, rst, start, stop, busy, scl, sda);
    end

endmodule
