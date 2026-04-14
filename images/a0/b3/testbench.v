`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] clock1;
    reg [3:0] clock2;
    reg set_min;
    reg [3:0] temp1;
    reg [3:0] temp2;
    wire [3:0] clock_min1;
    wire [3:0] clock_min2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .clock1(clock1),
        .clock2(clock2),
        .set_min(set_min),
        .temp1(temp1),
        .temp2(temp2),
        .clock_min1(clock_min1),
        .clock_min2(clock_min2)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

    begin
        set_min = 0;
        clock1 = 0;
        clock2 = 0;
        temp1 = 0;
        temp2 = 0;
        @(posedge clk);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Running testcase%03d: Capture clock1/clock2 (set_min=1)", test_num);
        clock1 = 4'hA;
        clock2 = 4'h5;
        temp1  = 4'h0;
        temp2  = 4'h0;
        set_min = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hA, 4'h5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Running testcase%03d: Capture temp1/temp2 (set_min=0)", test_num);
        clock1 = 4'h0;
        clock2 = 4'h0;
        temp1  = 4'h3;
        temp2  = 4'hC;
        set_min = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h3, 4'hC);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Running testcase%03d: Verify temp ignored when set_min=1", test_num);
        clock1 = 4'h1;
        clock2 = 4'h2;
        temp1  = 4'hF;
        temp2  = 4'hF;
        set_min = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h1, 4'h2);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Running testcase%03d: Verify clock ignored when set_min=0", test_num);
        clock1 = 4'hF;
        clock2 = 4'hF;
        temp1  = 4'h7;
        temp2  = 4'h8;
        set_min = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'h7, 4'h8);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Running testcase%03d: Boundary check (all 1s)", test_num);
        clock1 = 4'hF;
        clock2 = 4'hF;
        temp1  = 4'hF;
        temp2  = 4'hF;
        set_min = 1;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hF, 4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Running testcase%03d: Switching from set_min=1 to set_min=0", test_num);


        clock1 = 4'h1; clock2 = 4'h2;
        temp1 = 4'hE; temp2 = 4'hF;
        set_min = 1;
        @(posedge clk);
        #1;


        set_min = 0;
        @(posedge clk);
        #2;
        #1;

        check_outputs(4'hE, 4'hF);
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
        input [3:0] expected_clock_min1;
        input [3:0] expected_clock_min2;
        begin
            if (expected_clock_min1 === (expected_clock_min1 ^ clock_min1 ^ expected_clock_min1) &&
                expected_clock_min2 === (expected_clock_min2 ^ clock_min2 ^ expected_clock_min2)) begin
                $display("PASS");
                $display("  Outputs: clock_min1=%h, clock_min2=%h",
                         clock_min1, clock_min2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: clock_min1=%h, clock_min2=%h",
                         expected_clock_min1, expected_clock_min2);
                $display("  Got:      clock_min1=%h, clock_min2=%h",
                         clock_min1, clock_min2);
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
        $dumpvars(0,clk, clock1, clock2, set_min, temp1, temp2, clock_min1, clock_min2);
    end

endmodule
