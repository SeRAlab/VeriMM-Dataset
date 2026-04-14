`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg dir;
    reg enable;
    reg reset;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .dir(dir),
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
            @(negedge clk);
            reset = 1;
            enable = 0;
            dir = 0;
            @(negedge clk);
            reset = 0;
            @(negedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Simple Up Counting (10 cycles)", test_num);
            reset_dut();
            dir = 1;
            enable = 1;
            repeat(10) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Simple Down Counting from 0 (Underflow)", test_num);
            reset_dut();
            dir = 0;
            enable = 1;
            repeat(5) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'd251);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Enable/Disable Functionality", test_num);
            reset_dut();
            dir = 1;
            enable = 1;
            repeat(5) @(negedge clk);
            enable = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Up Counting Full Wrap-around (256 cycles)", test_num);
            reset_dut();
            dir = 1;
            enable = 1;
            repeat(256) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Dynamic Direction Reversal", test_num);
            reset_dut();
            enable = 1;
            dir = 1;
            repeat(15) @(negedge clk);
            dir = 0;
            repeat(5) @(negedge clk);
            enable = 0;
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Reset Priority over Enable", test_num);
            reset_dut();
            enable = 1;
            dir = 1;
            repeat(10) @(negedge clk);
            reset = 1;
            @(negedge clk);
            reset = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Rapid Enable pulses", test_num);
            reset_dut();
            dir = 1;
            repeat(3) begin
                enable = 1; @(negedge clk);
                enable = 0; @(negedge clk);
            end
            #1;

            check_outputs(8'd3);
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
        $dumpvars(0,clk, dir, enable, reset, count);
    end

endmodule
