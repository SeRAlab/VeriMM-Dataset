`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up_down;
    wire [9:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .en(en),
        .rst(rst),
        .up_down(up_down),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            en = 0;
            up_down = 1;
            rst = 0;
            #15;
            rst = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(10'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Up Count (10 cycles)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat (10) @(posedge clk);
            #2;
            #1;

            check_outputs(10'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Down Count (Underflow from 0)", test_num);
            reset_dut();
            en = 1;
            up_down = 0;
            repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(10'd1019);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Enable Control (Count for 5, hold for 5)", test_num);
            reset_dut();
            up_down = 1;
            en = 1;
            repeat (5) @(posedge clk);
            en = 0;
            repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(10'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Direction Change (Up 15, Down 5)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat (15) @(posedge clk);
            up_down = 0;
            repeat (5) @(posedge clk);
            #2;

            #1;


            check_outputs(10'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Overflow Wrap-around (1024 cycles)", test_num);
            reset_dut();
            en = 1;
            up_down = 1;
            repeat (1024) @(posedge clk);
            #2;

            #1;


            check_outputs(10'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter Testbench");
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
        input [9:0] expected_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h",
                         count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h",
                         expected_count);
                $display("  Got:      count=%h",
                         count);
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
        $dumpvars(0,clk, en, rst, up_down, count);
    end

endmodule
