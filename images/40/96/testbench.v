`timescale 1ns/1ps

module master_slave_d_latch_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg EN;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    master_slave_d_latch dut (
        .D(D),
        .EN(EN),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        EN = 0;
        forever #5 EN = ~EN;
    end

        task reset_dut;

        begin


            D = 0;
            if (EN == 0) begin
                @(posedge EN);
            end
            #1;
            if (EN == 1) begin
                @(negedge EN);
            end
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Transparency check (D=1)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge EN);
            #2 D = 1;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Hold value high (D=1 locked)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge EN);
            D = 1;
            @(negedge EN);
            #2 D = 0;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Hold value low (D=0 locked)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge EN);
            D = 1;
            #1 D = 0;
            @(negedge EN);
            #2 D = 1;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Follow input during EN=1");
            test_num = test_num + 1;
            reset_dut();

            @(posedge EN);
            #1 D = 1;
            #1 D = 0;
            #1 D = 1;
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Transparency check (D=0)");
            test_num = test_num + 1;
            reset_dut();

            @(posedge EN);
            D = 1;
            #1 D = 0;
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("master_slave_d_latch Testbench");
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
        $dumpvars(0,D, EN, Q);
    end

endmodule
