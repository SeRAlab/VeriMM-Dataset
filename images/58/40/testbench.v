`timescale 1ns/1ps

module sync_counter_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg RST;
    reg UP_DOWN;
    wire [2:0] Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sync_counter dut (
        .CLK(CLK),
        .RST(RST),
        .UP_DOWN(UP_DOWN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            RST = 1;
            UP_DOWN = 0;
            @(posedge CLK);
            #1 RST = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting up 4 cycles", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(4) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Up count rollover (8 cycles)", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(8) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Down count underflow from reset", test_num);
            reset_dut();
            UP_DOWN = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting down 3 cycles from 0", test_num);
            reset_dut();
            UP_DOWN = 0;
            repeat(3) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Switching direction (Up 5, Down 2)", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(5) @(posedge CLK);
            UP_DOWN = 0;
            repeat(2) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd3);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset during operation", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(3) @(posedge CLK);
            RST = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd0);
            RST = 0;
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Counting up to max value (7)", test_num);
            reset_dut();
            UP_DOWN = 1;
            repeat(7) @(posedge CLK);
            #1;
            #1;

            check_outputs(3'd7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sync_counter Testbench");
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
        $dumpvars(0,CLK, RST, UP_DOWN, Q);
    end

endmodule
