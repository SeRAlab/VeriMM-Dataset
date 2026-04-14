`timescale 1ns/1ps

module circular_shift_register_tb;

    // Testbench signals (sequential circuit)
    reg clk;
    wire [4:0] q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    circular_shift_register dut (
        .clk(clk),
        .q(q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            while (q !== 5'b00001) @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: Single Shift");
            reset_dut();
            @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Double Shift");
            reset_dut();
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Full 5-bit Rotation");
            reset_dut();
            repeat(5) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Shift to MSB position");
            reset_dut();
            repeat(4) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b10000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Multiple rotations (12 cycles)");
            reset_dut();
            repeat(12) @(posedge clk);
            #1;
            #1;

            check_outputs(5'b00100);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("circular_shift_register Testbench");
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
        input [4:0] expected_q;
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
        $dumpvars(0,clk, q);
    end

endmodule
