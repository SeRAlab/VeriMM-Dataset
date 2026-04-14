`timescale 1ns/1ps

module up_down_counter_3bit_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg en;
    reg rst;
    reg up_down;
    wire [2:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter_3bit dut (
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
            @(negedge clk);
            rst = 1;
            en = 0;
            up_down = 0;
            @(negedge clk);
            rst = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Reset Verification");
            reset_dut();
            #1;

            check_outputs(3'b000);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Basic Up Count");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Basic Down Count (Wrap from 0)");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 0;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Enable Signal Check");
            reset_dut();
            @(negedge clk);
            en = 0;
            up_down = 1;
            repeat(4) @(negedge clk);
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Full Up Cycle Wrap-around");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(8) @(negedge clk);
            en = 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Direction Switching");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(3) @(negedge clk);
            up_down = 0;
            repeat(2) @(negedge clk);
            en = 0;
            #1;

            check_outputs(3'd1);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Synchronous Reset Priority");
            reset_dut();
            @(negedge clk);
            en = 1;
            up_down = 1;
            repeat(4) @(negedge clk);
            rst = 1;
            @(negedge clk);
            rst = 0;
            en = 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase008;

        begin
            $display("Running testcase008: Toggle Enable");
            reset_dut();
            @(negedge clk);
            en = 1; up_down = 1;
            @(negedge clk);
            en = 0;
            @(negedge clk);
            en = 1;
            @(negedge clk);
            en = 0;
            #1;

            check_outputs(3'd2);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("up_down_counter_3bit Testbench");
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
        input [2:0] expected_count;
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
