`timescale 1ns/1ps

module watchdog_timer_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg [3:0] timeout_value;
    wire timeout_signal;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    watchdog_timer dut (
        .clk(clk),
        .reset(reset),
        .timeout_value(timeout_value),
        .timeout_signal(timeout_signal)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            timeout_cfg = 4'd0;
            @(posedge clk);
            #1 reset = 0;
        end
        endtask
    task wait_cycles;

        input integer n;
        begin
            repeat(n) @(posedge clk);
            #1;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Timeout (Value=5)", test_num);
            reset_dut();
            timeout_cfg = 4'd5;
            wait_cycles(6);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Reset Intervention", test_num);
            reset_dut();
            timeout_cfg = 4'd8;
            wait_cycles(4);
            reset = 1;
            @(posedge clk);
            #1 reset = 0;
            wait_cycles(4);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Maximum Timeout (Value=15)", test_num);
            reset_dut();
            timeout_cfg = 4'd15;
            wait_cycles(16);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Minimum Timeout (Value=1)", test_num);
            reset_dut();
            timeout_cfg = 4'd1;
            wait_cycles(2);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Continuous Reset Held", test_num);
            reset_dut();
            timeout_cfg = 4'd4;
            reset = 1;
            wait_cycles(10);
            #1;

            check_outputs(1'b0);
            reset = 0;
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Dynamic Configuration Change", test_num);
            reset_dut();
            timeout_cfg = 4'd10;
            wait_cycles(2);
            timeout_cfg = 4'd2;
            wait_cycles(3);
            #1;

            check_outputs(1'b1);
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
        input expected_timeout_signal;
        begin
            if (expected_timeout_signal === (expected_timeout_signal ^ timeout_signal ^ expected_timeout_signal)) begin
                $display("PASS");
                $display("  Outputs: timeout_signal=%b",
                         timeout_signal);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: timeout_signal=%b",
                         expected_timeout_signal);
                $display("  Got:      timeout_signal=%b",
                         timeout_signal);
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
        $dumpvars(0,clk, reset, timeout_value, timeout_signal);
    end

endmodule
