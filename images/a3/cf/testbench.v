`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [3:0] DATA;
    reg SHIFT_LEFT;
    reg SHIFT_RIGHT;
    wire [3:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DATA(DATA),
        .SHIFT_LEFT(SHIFT_LEFT),
        .SHIFT_RIGHT(SHIFT_RIGHT),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            SHIFT_LEFT = 0;
            SHIFT_RIGHT = 0;
            DATA = 4'b0000;
            @(posedge CLK);
            repeat(4) begin
                SHIFT_LEFT = 1;
                DATA = 4'b0000;
                @(posedge CLK);
            end
            SHIFT_LEFT = 0;
            DATA = 4'b0000;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Left Sequence (Expected: 1100)", test_num);
            reset_dut();


            DATA = 4'b1000; SHIFT_LEFT = 1; @(posedge CLK);

            DATA = 4'b1000; SHIFT_LEFT = 1; @(posedge CLK);

            DATA = 4'b0000; SHIFT_LEFT = 1; @(posedge CLK);

            DATA = 4'b0000; SHIFT_LEFT = 1; @(posedge CLK);

            SHIFT_LEFT = 0;
            #1;
            #1;

            check_outputs(4'b1100);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift Right Sequence (Expected: 0011)", test_num);
            reset_dut();


            DATA = 4'b0001; SHIFT_RIGHT = 1; @(posedge CLK);

            DATA = 4'b0001; SHIFT_RIGHT = 1; @(posedge CLK);

            DATA = 4'b0000; SHIFT_RIGHT = 1; @(posedge CLK);

            DATA = 4'b0000; SHIFT_RIGHT = 1; @(posedge CLK);

            SHIFT_RIGHT = 0;
            #1;
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Hold value (Expected: 1000)", test_num);
            reset_dut();


            DATA = 4'b1000; SHIFT_LEFT = 1; @(posedge CLK);
            repeat(3) begin
                DATA = 4'b0000; SHIFT_LEFT = 1; @(posedge CLK);
            end


            SHIFT_LEFT = 0;
            SHIFT_RIGHT = 0;
            DATA = 4'b1111;
            repeat(2) @(posedge CLK);

            #1;
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Left/Right (Expected: 0001)", test_num);
            reset_dut();

            DATA = 4'b1000; SHIFT_LEFT = 1; @(posedge CLK);
            DATA = 4'b1000; SHIFT_LEFT = 1; @(posedge CLK);
            DATA = 4'b0000; SHIFT_LEFT = 0; SHIFT_RIGHT = 1; @(posedge CLK);

            SHIFT_RIGHT = 0;
            #1;
            #1;

            check_outputs(4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Fill with 1s (Expected: 1111)", test_num);
            reset_dut();

            DATA = 4'b1001;
            SHIFT_LEFT = 1;
            repeat(4) @(posedge CLK);

            SHIFT_LEFT = 0;
            #1;
            #1;

            check_outputs(4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [3:0] expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%h",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h",
                         expected_Q);
                $display("  Got:      Q=%h",
                         Q);
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
        $dumpvars(0,CLK, DATA, SHIFT_LEFT, SHIFT_RIGHT, Q);
    end

endmodule
