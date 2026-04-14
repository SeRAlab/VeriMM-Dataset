`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [15:0] di;
    reg re;
    reg [3:0] wa;
    reg we;
    wire [15:0] do0;
    wire [15:0] do1;
    wire [15:0] do10;
    wire [15:0] do2;
    wire [15:0] do3;
    wire [15:0] do4;
    wire [15:0] do5;
    wire [15:0] do6;
    wire [15:0] do7;
    wire [15:0] do8;
    wire [15:0] do9;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .di(di),
        .re(re),
        .wa(wa),
        .we(we),
        .do0(do0),
        .do1(do1),
        .do10(do10),
        .do2(do2),
        .do3(do3),
        .do4(do4),
        .do5(do5),
        .do6(do6),
        .do7(do7),
        .do8(do8),
        .do9(do9)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            we = 0;
            re = 0;
            wa = 0;
            di = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Read Enable inactive", test_num);
            reset_dut();
            re = 0;
            we = 0;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx,
                          16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write and Read Address 0", test_num);
            reset_dut();

            wa = 0;
            di = 16'hAAAA;
            we = 1;
            @(posedge clk);
            #1;
            we = 0;
            re = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hAAAA, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx,
                          16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Fill all addresses", test_num);
            reset_dut();


            for (i = 0; i < 11; i = i + 1) begin
                wa = i;
                di = 16'hB000 + i;
                we = 1;
                @(posedge clk);
                #1;
            end

            we = 0;
            re = 1;
            @(posedge clk);
            #1;


            #1;



            check_outputs(16'hB000, 16'hB001, 16'hB00A, 16'hB002, 16'hB003,
                          16'hB004, 16'hB005, 16'hB006, 16'hB007, 16'hB008, 16'hB009);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Write Enable check", test_num);
            reset_dut();


            wa = 5;
            di = 16'h5555;
            we = 1;
            @(posedge clk);
            #1;


            di = 16'hEEEE;
            we = 0;
            @(posedge clk);
            #1;

            re = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx,
                          16'hxxxx, 16'h5555, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overwrite check", test_num);
            reset_dut();


            wa = 10;
            di = 16'h1111;
            we = 1;
            @(posedge clk);
            #1;


            wa = 10;
            di = 16'hFFFF;
            we = 1;
            @(posedge clk);
            #1;

            we = 0;
            re = 1;
            @(posedge clk);
            #1;

            #1;


            check_outputs(16'hxxxx, 16'hxxxx, 16'hFFFF, 16'hxxxx, 16'hxxxx,
                          16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx, 16'hxxxx);
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
        input [15:0] expected_do0;
        input [15:0] expected_do1;
        input [15:0] expected_do10;
        input [15:0] expected_do2;
        input [15:0] expected_do3;
        input [15:0] expected_do4;
        input [15:0] expected_do5;
        input [15:0] expected_do6;
        input [15:0] expected_do7;
        input [15:0] expected_do8;
        input [15:0] expected_do9;
        begin
            if (expected_do0 === (expected_do0 ^ do0 ^ expected_do0) &&
                expected_do1 === (expected_do1 ^ do1 ^ expected_do1) &&
                expected_do10 === (expected_do10 ^ do10 ^ expected_do10) &&
                expected_do2 === (expected_do2 ^ do2 ^ expected_do2) &&
                expected_do3 === (expected_do3 ^ do3 ^ expected_do3) &&
                expected_do4 === (expected_do4 ^ do4 ^ expected_do4) &&
                expected_do5 === (expected_do5 ^ do5 ^ expected_do5) &&
                expected_do6 === (expected_do6 ^ do6 ^ expected_do6) &&
                expected_do7 === (expected_do7 ^ do7 ^ expected_do7) &&
                expected_do8 === (expected_do8 ^ do8 ^ expected_do8) &&
                expected_do9 === (expected_do9 ^ do9 ^ expected_do9)) begin
                $display("PASS");
                $display("  Outputs: do0=%h, do1=%h, do10=%h, do2=%h, do3=%h, do4=%h, do5=%h, do6=%h, do7=%h, do8=%h, do9=%h",
                         do0, do1, do10, do2, do3, do4, do5, do6, do7, do8, do9);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: do0=%h, do1=%h, do10=%h, do2=%h, do3=%h, do4=%h, do5=%h, do6=%h, do7=%h, do8=%h, do9=%h",
                         expected_do0, expected_do1, expected_do10, expected_do2, expected_do3, expected_do4, expected_do5, expected_do6, expected_do7, expected_do8, expected_do9);
                $display("  Got:      do0=%h, do1=%h, do10=%h, do2=%h, do3=%h, do4=%h, do5=%h, do6=%h, do7=%h, do8=%h, do9=%h",
                         do0, do1, do10, do2, do3, do4, do5, do6, do7, do8, do9);
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
        $dumpvars(0,clk, di, re, wa, we, do0, do1, do10, do2, do3, do4, do5, do6, do7, do8, do9);
    end

endmodule
