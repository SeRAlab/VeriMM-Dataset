`timescale 1ns/1ps

module deadbeat_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg [3:0] r_input;
    reg rst;
    reg [3:0] x_current;
    wire [3:0] x_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    deadbeat_controller dut (
        .clk(clk),
        .r_input(r_input),
        .rst(rst),
        .x_current(x_current),
        .x_next(x_next)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            r_input = 4'd0;
            x_current = 4'd0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Basic tracking (Ref: 5, Current: 0)", test_num);
            reset_dut();
            r_input = 4'd5;
            x_current = 4'd0;

            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Non-zero starting state (Ref: 10, Current: 3)", test_num);
            reset_dut();
            r_input = 4'd10;
            x_current = 4'd3;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd10);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Step down to zero (Ref: 0, Current: 15)", test_num);
            reset_dut();
            r_input = 4'd0;
            x_current = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum values (Ref: 15, Current: 15)", test_num);
            reset_dut();
            r_input = 4'd15;
            x_current = 4'd15;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Reset behavior verification", test_num);
            reset_dut();
            r_input = 4'd7;
            x_current = 4'd2;
            rst = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(4'd0);
            rst = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("deadbeat_controller Testbench");
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
        input [3:0] expected_x_next;
        begin
            if (expected_x_next === (expected_x_next ^ x_next ^ expected_x_next)) begin
                $display("PASS");
                $display("  Outputs: x_next=%h",
                         x_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x_next=%h",
                         expected_x_next);
                $display("  Got:      x_next=%h",
                         x_next);
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
        $dumpvars(0,clk, r_input, rst, x_current, x_next);
    end

endmodule
