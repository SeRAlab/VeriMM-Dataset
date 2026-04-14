`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg kick;
    reg rst;
    reg [3:0] timeout;
    wire timeout_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .kick(kick),
        .rst(rst),
        .timeout(timeout),
        .timeout_out(timeout_out)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            kick = 0;
            timeout = 0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Standard Timeout Trigger", test_num);
            reset_dut();
            timeout = 4'd5;
            repeat (7) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Kick prevents timeout", test_num);
            reset_dut();
            timeout = 4'd8;
            repeat (4) @(posedge clk);
            kick = 1;
            @(posedge clk);
            kick = 0;
            repeat (3) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Timeout after a kick", test_num);
            reset_dut();
            timeout = 4'd4;
            kick = 1;
            @(posedge clk);
            kick = 0;
            repeat (6) @(posedge clk);
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Kick clears timeout_out", test_num);
            reset_dut();
            timeout = 4'd3;
            repeat (5) @(posedge clk);
            kick = 1;
            @(posedge clk);
            kick = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Reset clears timeout_out", test_num);
            reset_dut();
            timeout = 4'd3;
            repeat (5) @(posedge clk);
            rst = 1;
            @(posedge clk);
            rst = 0;
            @(posedge clk);
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("watchdog_timer Testbench");
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
        input expected_timeout_out;
        begin
            if (expected_timeout_out === (expected_timeout_out ^ timeout_out ^ expected_timeout_out)) begin
                $display("PASS");
                $display("  Outputs: timeout_out=%b",
                         timeout_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout_out=%b",
                         expected_timeout_out);
                $display("  Got:      timeout_out=%b",
                         timeout_out);
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
        $dumpvars(0,clk, kick, rst, timeout, timeout_out);
    end

endmodule
