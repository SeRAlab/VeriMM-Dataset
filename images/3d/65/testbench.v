`timescale 1ns/1ps

module master_slave_d_latch_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg E;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    master_slave_d_latch dut (
        .C(C),
        .D(D),
        .E(E),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

        begin
            D = 0;
            E = 0;
            @(negedge C);
            E = 1; D = 0;
            @(posedge C);
            E = 0;
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case 001: Standard Write 1");
            reset_dut();
            @(negedge C);
            E = 1; D = 1;
            @(posedge C);
            E = 0;
            #1;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case 002: Standard Write 0");
            reset_dut();

            @(negedge C); E = 1; D = 1;
            @(posedge C); E = 0;

            @(negedge C); E = 1; D = 0;
            @(posedge C); E = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case 003: Master Inhibition (E=0 while C=0)");
            reset_dut();
            @(negedge C);
            E = 0; D = 1;
            @(posedge C);
            E = 0;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case 004: Slave Inhibition (E=1 while C=1)");
            reset_dut();
            @(negedge C);
            E = 1; D = 1;
            @(posedge C);
            E = 1;
            #1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case 005: Master Transparency Check");
            reset_dut();
            @(negedge C);
            E = 1;
            D = 1; #1;
            D = 0; #1;
            D = 1; #1;
            @(posedge C);
            E = 0;
            #1;
            #1;

            check_outputs(1'b1);
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
        $dumpvars(0,C, D, E, Q);
    end

endmodule
