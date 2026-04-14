`timescale 1ns/1ps

module state_space_controller_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    reg rst;
    reg [15:0] u;
    reg [15:0] x1;
    reg [15:0] x2;
    wire [15:0] x1_next;
    wire [15:0] x2_next;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    state_space_controller dut (
        .clk(clk),
        .rst(rst),
        .u(u),
        .x1(x1),
        .x2(x2),
        .x1_next(x1_next),
        .x2_next(x2_next)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            u = 0;
            x1 = 0;
            x2 = 0;
            @(posedge clk);
            #1 rst = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            $display("\nRunning Testcase 001: Unit x1 Input");
            reset_dut();
            test_num = 1;
            x1 = 16'h0001;
            x2 = 16'h0000;
            u  = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0002, 16'h0001);
        end
        endtask

    task testcase002;

        begin
            $display("\nRunning Testcase 002: Unit x2 Input");
            reset_dut();
            test_num = 2;
            x1 = 16'h0000;
            x2 = 16'h0001;
            u  = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0001, 16'h0002);
        end
        endtask

    task testcase003;

        begin
            $display("\nRunning Testcase 003: Unit Control Input");
            reset_dut();
            test_num = 3;
            x1 = 16'h0000;
            x2 = 16'h0000;
            u  = 16'h0001;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0001, 16'h0001);
        end
        endtask

    task testcase004;

        begin
            $display("\nRunning Testcase 004: Zero Inputs");
            reset_dut();
            test_num = 4;
            x1 = 16'h0000;
            x2 = 16'h0000;
            u  = 16'h0000;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h0000, 16'h0000);
        end
        endtask

    task testcase005;

        begin
            $display("\nRunning Testcase 005: Mixed Inputs");
            reset_dut();
            test_num = 5;
            x1 = 16'd10;
            x2 = 16'd20;
            u  = 16'd5;
            @(posedge clk);
            #2;
            #1;

            check_outputs(16'h002D, 16'h0037);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("state_space_controller Testbench");
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
        input [15:0] expected_x1_next;
        input [15:0] expected_x2_next;
        begin
            if (expected_x1_next === (expected_x1_next ^ x1_next ^ expected_x1_next) &&
                expected_x2_next === (expected_x2_next ^ x2_next ^ expected_x2_next)) begin
                $display("PASS");
                $display("  Outputs: x1_next=%h, x2_next=%h",
                         x1_next, x2_next);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: x1_next=%h, x2_next=%h",
                         expected_x1_next, expected_x2_next);
                $display("  Got:      x1_next=%h, x2_next=%h",
                         x1_next, x2_next);
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
        $dumpvars(0,clk, rst, u, x1, x2, x1_next, x2_next);
    end

endmodule
