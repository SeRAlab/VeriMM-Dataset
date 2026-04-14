`timescale 1ns/1ps

module T_latch_tb;

    // Testbench signals (sequential circuit)
    reg T;
    reg clk;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    T_latch dut (
        .T(T),
        .clk(clk),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            T = 0;


            @(negedge clk);
            if (Q === 1'b1) begin
                T = 1;
                @(negedge clk);
                T = 0;
                @(negedge clk);
            end else if (Q === 1'bx) begin


                T = 1;
                @(negedge clk);
                T = 0;
                @(negedge clk);
            end
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: No toggle (T=0)");
            reset_dut();
            T = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: Single toggle (T=1 for 1 cycle)");
            reset_dut();
            T = 1;
            @(negedge clk);
            T = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: Double toggle (T=1 for 2 cycles)");
            reset_dut();
            T = 1;
            repeat(2) @(negedge clk);
            T = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: Triple toggle (T=1 for 3 cycles)");
            reset_dut();
            T = 1;
            repeat(3) @(negedge clk);
            T = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: Toggle then Hold (T=1 then T=0)");
            reset_dut();
            T = 1;
            @(negedge clk);
            T = 0;
            repeat(2) @(negedge clk);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: Intermittent Toggling (1-0-1)");
            reset_dut();
            T = 1; @(negedge clk);
            T = 0; @(negedge clk);
            T = 1; @(negedge clk);
            T = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: Extended Hold (T=0 for 5 cycles)");
            reset_dut();
            T = 0;
            repeat(5) @(negedge clk);
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
        $display("T_latch Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        input expected_Q;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q)) begin
                $display("PASS");
                $display("  Outputs: Q=%b",
                         Q);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b",
                         expected_Q);
                $display("  Got:      Q=%b",
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
        $dumpvars(0,T, clk, Q);
    end

endmodule
