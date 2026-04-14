`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg reset;
    reg up;
    wire [7:0] count;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
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
            test_num = test_num + 1;
            $display("Testcase %0d: Synchronous Reset Check", test_num);
            reset_dut();

            @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Increment (Up=1)", test_num);
            reset_dut();
            up = 1;
            repeat(10) @(negedge clk);
            #1;

            check_outputs(8'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple Decrement (Underflow from 0)", test_num);
            reset_dut();
            up = 0;
            repeat(1) @(negedge clk);
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Multiple Decrements", test_num);
            reset_dut();
            up = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'hFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Increment then Decrement", test_num);
            reset_dut();
            up = 1;
            repeat(20) @(negedge clk);
            up = 0;
            repeat(5) @(negedge clk);
            #1;

            check_outputs(8'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Overflow Wrap-around (255 to 0)", test_num);
            reset_dut();
            up = 1;
            repeat(256) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Priority over Up signal", test_num);
            reset_dut();
            up = 1;
            repeat(5) @(negedge clk);
            reset = 1;
            repeat(1) @(negedge clk);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed Up/Down switching", test_num);
            reset_dut();
            up = 1; repeat(2) @(negedge clk);
            up = 0; repeat(1) @(negedge clk);
            up = 1; repeat(5) @(negedge clk);
            up = 0; repeat(2) @(negedge clk);
            #1;

            check_outputs(8'd4);
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
        $dumpvars(0,clk, reset, up, count);
    end

endmodule
