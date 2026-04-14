`timescale 1ns/1ps

module new_module_4_tb;

    // Testbench signals (sequential circuit)
    reg clock;
    reg j;
    wire k;
    wire l;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    new_module_4 dut (
        .clock(clock),
        .j(j),
        .k(k),
        .l(l)
    );

    // Clock generation (10ns period)
    initial begin
        clock = 0;
        forever #5 clock = ~clock;
    end

        task reset_dut;

        begin
            j = 0;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            j = 1;
            @(posedge clock);
            #2;
            $display("Testcase 001: Initial Transition");
            #1;

            check_outputs(1'b1, 1'bx);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            j = 1;
            repeat(2) @(posedge clock);
            #2;
            $display("Testcase 002: Second Transition");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            j = 1;
            repeat(3) @(posedge clock);
            #2;
            $display("Testcase 003: Third Transition");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            j = 1;
            repeat(4) @(posedge clock);
            #2;
            $display("Testcase 004: Fourth Transition (Entering Loop)");
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            j = 1;
            repeat(5) @(posedge clock);
            #2;
            $display("Testcase 005: Fifth Transition (Looping)");
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            j = 1;
            repeat(2) @(posedge clock);
            j = 0;
            repeat(2) @(posedge clock);
            #2;
            $display("Testcase 006: Hold state with j=0");
            #1;

            check_outputs(1'b1, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("new_module_4 Testbench");
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
        input expected_k;
        input expected_l;
        begin
            if (expected_k === (expected_k ^ k ^ expected_k) &&
                expected_l === (expected_l ^ l ^ expected_l)) begin
                $display("PASS");
                $display("  Outputs: k=%b, l=%b",
                         k, l);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: k=%b, l=%b",
                         expected_k, expected_l);
                $display("  Got:      k=%b, l=%b",
                         k, l);
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
        $dumpvars(0,clock, j, k, l);
    end

endmodule
