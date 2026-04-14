`timescale 1ns/1ps

module binary_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg enable;
    wire [11:0] count;
    wire terminal_count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_counter dut (
        .clk(clk),
        .enable(enable),
        .count(count),
        .terminal_count(terminal_count)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            enable = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Basic Counting (10 steps)", test_num);
            reset_dut();
            enable = 1;
            repeat(10) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(12'd10, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Enable/Disable Functionality", test_num);
            reset_dut();
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            repeat(5) @(posedge clk);
            enable = 1;
            repeat(5) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(12'd10, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %03d: Terminal Count at Max Value", test_num);
            reset_dut();
            enable = 1;

            repeat(4095) @(posedge clk);
            #1;
            #1;

            check_outputs(12'hFFF, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: Wrap-around to Zero", test_num);
            reset_dut();
            enable = 1;
            repeat(4096) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(12'h000, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %03d: Counting to 1024", test_num);
            reset_dut();
            enable = 1;
            repeat(1024) @(posedge clk);
            enable = 0;
            #1;
            #1;

            check_outputs(12'd1024, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_counter Testbench");
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
        input [11:0] expected_count;
        input expected_terminal_count;
        begin
            if (expected_count === (expected_count ^ count ^ expected_count) &&
                expected_terminal_count === (expected_terminal_count ^ terminal_count ^ expected_terminal_count)) begin
                $display("PASS");
                $display("  Outputs: count=%h, terminal_count=%b",
                         count, terminal_count);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: count=%h, terminal_count=%b",
                         expected_count, expected_terminal_count);
                $display("  Got:      count=%h, terminal_count=%b",
                         count, terminal_count);
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
        $dumpvars(0,clk, enable, count, terminal_count);
    end

endmodule
