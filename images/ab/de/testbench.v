`timescale 1ns/1ps

module johnson_counter_with_enable_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    johnson_counter_with_enable dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
        .count(count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            @(posedge clk);
            reset = 1;
            enable = 0;
            @(posedge clk);
            reset = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Synchronous Reset...");
            test_num = 1;
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Single Step Advance...");
            test_num = 2;
            reset_dut();
            @(posedge clk);
            enable = 1;
            @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(8'h01);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: 8-Step Advance (Saturation to FF)...");
            test_num = 3;
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (8) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Full 16-Step Cycle...");
            test_num = 4;
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (16) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Enable/Hold Functionality...");
            test_num = 5;
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (4) @(posedge clk);
            enable = 0;
            repeat (5) @(posedge clk);
            #1;
            #1;

            check_outputs(8'h0F);
        end
        endtask

    task testcase006;

        begin
            $display("\nRunning Testcase 006: Partial Loop (Downwards sequence)...");
            test_num = 6;
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (12) @(posedge clk);
            enable = 0;
            #1;

            #1;


            check_outputs(8'hF0);
        end
        endtask

    task testcase007;

        begin
            $display("\nRunning Testcase 007: Reset Priority Over Enable...");
            test_num = 7;
            reset_dut();
            @(posedge clk);
            enable = 1;
            repeat (5) @(posedge clk);
            reset = 1;
            @(posedge clk);
            reset = 0;
            enable = 0;
            #1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("johnson_counter_with_enable Testbench");
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
        input [7:0] expected_count;
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
        $dumpvars(0,clk, enable, reset, count);
    end

endmodule
