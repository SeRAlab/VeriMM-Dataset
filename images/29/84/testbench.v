`timescale 1ns/1ps

module timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [31:0] countdown_value;
    reg rst;
    reg start;
    reg stop;
    wire timer_done;
    wire [31:0] timer_value;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    timer dut (
        .clk(clk),
        .countdown_value(countdown_value),
        .rst(rst),
        .start(start),
        .stop(stop),
        .timer_done(timer_done),
        .timer_value(timer_value)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            start = 0;
            stop = 0;
            countdown_value = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset and Idle Check", test_num);
            reset_dut();


            repeat(5) @(posedge clk);
            #1;

            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Basic Start and Count", test_num);
            reset_dut();
            countdown_value = 32'h000000FF;
            start = 1;
            repeat(10) @(posedge clk);
            start = 0;
            #1;

            check_outputs(1'b0, 32'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Reach Target Value (Done Signal)", test_num);
            reset_dut();
            countdown_value = 32'd15;
            start = 1;
            repeat(15) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1, 32'd15);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Stop and Hold Value", test_num);
            reset_dut();
            countdown_value = 32'hFFFF;
            start = 1;
            repeat(20) @(posedge clk);
            stop = 1;
            start = 0;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'd20);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Resume after Stop", test_num);
            reset_dut();
            countdown_value = 32'hFFFF;
            start = 1;
            repeat(10) @(posedge clk);
            stop = 1;
            start = 0;
            repeat(5) @(posedge clk);
            stop = 0;
            start = 1;
            repeat(10) @(posedge clk);

            #1;


            check_outputs(1'b0, 32'd20);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %03d: Reset during operation", test_num);
            reset_dut();
            countdown_value = 32'hFFFF;
            start = 1;
            repeat(50) @(posedge clk);
            rst = 1;
            @(posedge clk);
            #1 rst = 0;

            #1;


            check_outputs(1'b1, 32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("timer Testbench");
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
        input expected_timer_done;
        input [31:0] expected_timer_value;
        begin
            if (expected_timer_done === (expected_timer_done ^ timer_done ^ expected_timer_done) &&
                expected_timer_value === (expected_timer_value ^ timer_value ^ expected_timer_value)) begin
                $display("PASS");
                $display("  Outputs: timer_done=%b, timer_value=%h",
                         timer_done, timer_value);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timer_done=%b, timer_value=%h",
                         expected_timer_done, expected_timer_value);
                $display("  Got:      timer_done=%b, timer_value=%h",
                         timer_done, timer_value);
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
        $dumpvars(0,clk, countdown_value, rst, start, stop, timer_done, timer_value);
    end

endmodule
