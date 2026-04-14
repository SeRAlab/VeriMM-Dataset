`timescale 1ns/1ps

module updown_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg reset;
    wire [2:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    updown_counter dut (
        .clk(clk),
        .dir(dir),
        .reset(reset),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            dir = 0;
            reset = 1;
            @(posedge clk);
            #1;
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset check");
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Single Increment");
            reset_dut();
            dir = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b001);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Increment 3 times");
            reset_dut();
            dir = 1;
            repeat(3) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Decrement from 0 (Underflow)");
            reset_dut();
            dir = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b111);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full wrap-around up (8 cycles)");
            reset_dut();
            dir = 1;
            repeat(8) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Switch direction (Up 5, Down 2)");
            reset_dut();
            dir = 1;
            repeat(5) @(posedge clk);
            dir = 0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(3'b011);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Reset override");
            reset_dut();
            dir = 1;
            repeat(4) @(posedge clk);
            reset = 1;
            @(posedge clk);
            #1;
            #1;

            check_outputs(3'b000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("updown_counter Testbench");
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
        input [2:0] expected_q;
        begin
            if (expected_q === (expected_q ^ q ^ expected_q)) begin
                $display("PASS");
                $display("  Outputs: q=%h",
                         q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q=%h",
                         expected_q);
                $display("  Got:      q=%h",
                         q);
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
        $dumpvars(0,clk, dir, reset, q);
    end

endmodule
