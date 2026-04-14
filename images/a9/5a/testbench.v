`timescale 1ns/1ps

module counter_3bit_sync_reset_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RESET;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    counter_3bit_sync_reset dut (
        .CLK(CLK),
        .RESET(RESET),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RESET = 1;
            @(posedge CLK);
            #1;
            RESET = 0;

        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Counting to 3", test_num);
            reset_dut();
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Full wrap-around (8 cycles)", test_num);
            reset_dut();
            repeat(8) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset during operation", test_num);
            reset_dut();
            repeat(4) @(posedge CLK);
            RESET = 1;
            @(posedge CLK);
            #1;
            RESET = 0;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Count to 7", test_num);
            reset_dut();
            repeat(7) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large count (11 cycles)", test_num);
            reset_dut();
            repeat(11) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Persistent reset", test_num);
            reset_dut();
            RESET = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
            RESET = 0;
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("counter_3bit_sync_reset Testbench");
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
        input [2:0] expected_Q;
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
        $dumpvars(0,CLK, RESET, Q);
    end

endmodule
