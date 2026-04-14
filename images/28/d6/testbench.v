`timescale 1ns/1ps

module UpDownCounter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    UpDownCounter dut (
        .clk(clk),
        .reset(reset),
        .up(up),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(negedge clk);
            reset = 1;
            up = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Reset check", test_num);
            reset_dut();

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        integer i;
        begin
            test_num = 2;
            $display("Testcase %03d: Count up 5 times", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 5; i = i + 1) @(negedge clk);

            #1;


            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Wrap around counting up (16 steps)", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 16; i = i + 1) @(negedge clk);

            #1;


            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Count down from 0 (expect 15)", test_num);
            reset_dut();
            up = 0;
            @(negedge clk);

            #1;


            check_outputs(4'hF);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %03d: Count down 3 steps from 0", test_num);
            reset_dut();
            up = 0;
            for (i = 0; i < 3; i = i + 1) @(negedge clk);

            #1;


            check_outputs(4'hD);
        end
        endtask

    task testcase006;

        integer i;
        begin
            test_num = 6;
            $display("Testcase %03d: Count up to 15", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 15; i = i + 1) @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase007;

        integer i;
        begin
            test_num = 7;
            $display("Testcase %03d: Count up 10, then down 4", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 10; i = i + 1) @(negedge clk);
            up = 0;
            for (i = 0; i < 4; i = i + 1) @(negedge clk);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase008;

        integer i;
        begin
            test_num = 8;
            $display("Testcase %03d: Wrap around up then back down", test_num);
            reset_dut();
            up = 1;
            for (i = 0; i < 17; i = i + 1) @(negedge clk);
            up = 0;
            for (i = 0; i < 2; i = i + 1) @(negedge clk);
            #1;

            check_outputs(4'hF);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("UpDownCounter Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input [3:0] expected_count;
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
        $dumpvars(0,clk, reset, up, count);
    end

endmodule
