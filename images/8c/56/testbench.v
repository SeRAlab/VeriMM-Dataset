`timescale 1ns/1ps

module up_down_counter_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg down;
    reg rst;
    reg up;
    wire [3:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    up_down_counter dut (
        .clk(clk),
        .down(down),
        .rst(rst),
        .up(up),
        .q(q)
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
        up = 0;
        down = 0;
        @(negedge clk);
        rst = 0;
    end
        endtask
    task drive_inputs;

        input i_up;
        input i_down;
        begin
            @(negedge clk);
            up = i_up;
            down = i_down;
        end
        endtask

    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Reset Check", test_num);
        reset_dut();
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Increment 7 times", test_num);
        reset_dut();
        repeat(7) begin
            drive_inputs(1, 0);
        end
        drive_inputs(0, 0);
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Decrement from 0 (Wrap-around to F)", test_num);
        reset_dut();
        drive_inputs(0, 1);
        drive_inputs(0, 0);
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Increment to Overflow (15 -> 0)", test_num);
        reset_dut();
        repeat(16) begin
            drive_inputs(1, 0);
        end
        drive_inputs(0, 0);
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Bidirectional (Up 10, Down 4)", test_num);
        reset_dut();
        repeat(10) drive_inputs(1, 0);
        repeat(4)  drive_inputs(0, 1);
        drive_inputs(0, 0);
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Running Testcase %0d: Idle State (No Up/Down)", test_num);
        reset_dut();
        repeat(5) drive_inputs(1, 0);
        repeat(5) drive_inputs(0, 0);
        #1;

        check_outputs(4'h5);
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
        input [3:0] expected_q;
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
        $dumpvars(0,clk, down, rst, up, q);
    end

endmodule
