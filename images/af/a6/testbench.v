`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg en;
    reg sreset;
    wire [5:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .dir(dir),
        .en(en),
        .sreset(sreset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            sreset = 1;
            en = 0;
            dir = 0;
            @(posedge clk);
            #1;
            sreset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase 001: Counting up for 10 cycles");
            reset_dut();
            en = 1;
            dir = 1;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase 002: Counting down for 5 cycles (from 0)");
            reset_dut();
            en = 1;
            dir = 0;
            repeat (5) @(negedge clk);

            #1;


            check_outputs(6'd59);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase 003: Count up 5, then disable for 5");
            reset_dut();
            en = 1;
            dir = 1;
            repeat (5) @(negedge clk);
            en = 0;
            repeat (5) @(negedge clk);
            #1;

            check_outputs(6'd5);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase 004: Count up past 63 (Wrap-around)");
            reset_dut();
            en = 1;
            dir = 1;
            repeat (65) @(negedge clk);

            #1;


            check_outputs(6'd1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase 005: Count up 20, then down 10");
            reset_dut();
            en = 1;
            dir = 1;
            repeat (20) @(negedge clk);
            dir = 0;
            repeat (10) @(negedge clk);
            #1;

            check_outputs(6'd10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase 006: Reset while counting");
            reset_dut();
            en = 1;
            dir = 1;
            repeat (15) @(negedge clk);
            sreset = 1;
            @(negedge clk);
            sreset = 0;
            #1;

            check_outputs(6'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase 007: Disable while counting down");
            reset_dut();
            en = 1;
            dir = 0;
            repeat (10) @(negedge clk);
            en = 0;
            repeat (3) @(negedge clk);
            #1;

            check_outputs(6'd54);
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
        input [5:0] expected_count;
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
        $dumpvars(0,clk, dir, en, sreset, count);
    end

endmodule
