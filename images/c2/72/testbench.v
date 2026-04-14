`timescale 1ns/1ps

module dff_with_enable_and_set_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg E;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    dff_with_enable_and_set dut (
        .C(C),
        .D(D),
        .E(E),
        .S(S),
        .Q(Q)
    );

    // Clock generation (10ns period)
    initial begin
        C = 0;
        forever #5 C = ~C;
    end

        task reset_dut;

    begin

        E = 1;
        S = 0;
        D = 0;
        @(negedge C);
        #1;
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        reset_dut();
        $display("Testcase 001: Testing Synchronous Set (S=1, E=1)");
        E = 1;
        S = 1;
        D = 0;
        @(negedge C);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        reset_dut();
        $display("Testcase 002: Testing Latch D=0 (S=0, E=1)");

        E = 1; S = 1; @(negedge C); #1;

        E = 1;
        S = 0;
        D = 0;
        @(negedge C);
        #2 #1;
 check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        reset_dut();
        $display("Testcase 003: Testing Latch D=1 (S=0, E=1)");
        E = 1;
        S = 0;
        D = 1;
        @(negedge C);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        reset_dut();
        $display("Testcase 004: Testing Enable=0 (Hold state)");

        E = 1; S = 0; D = 1;
        @(negedge C); #1;


        E = 0;
        S = 0;
        D = 0;
        @(negedge C);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        reset_dut();
        $display("Testcase 005: Testing S priority over D (E=1, S=1, D=0)");
        E = 1;
        S = 1;
        D = 0;
        @(negedge C);
        #2 #1;
 check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        reset_dut();
        $display("Testcase 006: Testing falling-edge sensitivity (Checking no change on posedge)");

        E = 1; S = 0; D = 0;
        @(negedge C); #1;


        E = 1; S = 0; D = 1;
        @(posedge C);
        #1;
        if (Q === 1'b0) begin

            @(negedge C);
            #2 #1;
 check_outputs(1'b1);
        end else begin
            $display("FAIL: Output changed on positive edge");
            fail_count = fail_count + 1;
        end
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("dff_with_enable_and_set Testbench");
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
        $dumpvars(0,C, D, E, S, Q);
    end

endmodule
