`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    reg reset;
    reg up_down;
    wire [3:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .enable(enable),
        .reset(reset),
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
            @(negedge clk);
            reset = 1;
            enable = 0;
            up_down = 0;
            @(negedge clk);
            reset = 0;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Reset Check");
            reset_dut();
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Up Counting (0 to 5)");
            reset_dut();
            up_down = 1;
            enable = 1;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Down Counting (Wrap from 0 to 14)");
            reset_dut();
            up_down = 0;
            enable = 1;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Enable Signal (Hold value when disabled)");
            reset_dut();
            up_down = 1;
            enable = 1;
            repeat(3) @(negedge clk);
            enable = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Up Wrap Around (14 to 1)");
            reset_dut();
            up_down = 1;
            enable = 1;
            repeat(17) @(negedge clk);
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Direction Switching (Up 10, Down 4)");
            reset_dut();
            enable = 1;
            up_down = 1;
            repeat(10) @(negedge clk);
            up_down = 0;
            repeat(4) @(negedge clk);
            #1;

            check_outputs(4'h6);
        end
        endtask

    task testcase007;

        begin
            $display("Testcase 007: Full Down Cycle Wrap");
            reset_dut();
            enable = 1;
            up_down = 0;
            repeat(16) @(negedge clk);
            #1;

            check_outputs(4'h0);
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
        $dumpvars(0,clk, enable, reset, up_down, count);
    end

endmodule
