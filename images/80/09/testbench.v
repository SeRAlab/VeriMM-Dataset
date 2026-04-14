`timescale 1ns/1ps

module stopwatch_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg start;
    reg stop;
    wire [6:0] seg0;
    wire [6:0] seg1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    stopwatch dut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .stop(stop),
        .seg0(seg0),
        .seg1(seg1)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            start = 0;
            stop = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial Reset State", test_num);
            reset_dut();


            #1;



            check_outputs(7'h3f, 7'h3f);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Basic Counting to 5", test_num);
            reset_dut();
            start = 1;
            repeat (5) @(posedge clk);
            start = 0;


            #1;



            check_outputs(7'h6d, 7'h3f);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Stop/Pause Functionality", test_num);
            reset_dut();
            start = 1;
            repeat (3) @(posedge clk);
            start = 0;
            stop = 1;
            repeat (5) @(posedge clk);


            #1;



            check_outputs(7'h4f, 7'h3f);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Tens Place Increment", test_num);
            reset_dut();
            start = 1;
            repeat (12) @(posedge clk);
            start = 0;


            #1;



            check_outputs(7'h5b, 7'h06);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Wrap Around (99 to 00)", test_num);
            reset_dut();
            start = 1;
            repeat (100) @(posedge clk);
            start = 0;

            #1;


            check_outputs(7'h3f, 7'h3f);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Reset During Counting", test_num);
            reset_dut();
            start = 1;
            repeat (25) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;

            #1;


            check_outputs(7'h3f, 7'h3f);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("stopwatch Testbench");
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
        input [6:0] expected_seg0;
        input [6:0] expected_seg1;
        begin
            if (expected_seg0 === (expected_seg0 ^ seg0 ^ expected_seg0) &&
                expected_seg1 === (expected_seg1 ^ seg1 ^ expected_seg1)) begin
                $display("PASS");
                $display("  Outputs: seg0=%h, seg1=%h",
                         seg0, seg1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg0=%h, seg1=%h",
                         expected_seg0, expected_seg1);
                $display("  Got:      seg0=%h, seg1=%h",
                         seg0, seg1);
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
        $dumpvars(0,clk, reset, start, stop, seg0, seg1);
    end

endmodule
