`timescale 1ns/1ps

module DFFSR_tb;

    // Testbench signals (sequential circuit)
    reg C;
    reg D;
    reg R;
    reg S;
    wire Q;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    DFFSR dut (
        .C(C),
        .D(D),
        .R(R),
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
            R = 1;
            S = 0;
            D = 0;
            @(posedge C);
            #1;
            R = 0;
            @(posedge C);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Synchronous Reset Priority", test_num);
            reset_dut();
            D = 1;
            S = 1;
            R = 1;
            @(posedge C);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Synchronous Set", test_num);
            reset_dut();
            D = 0;
            S = 1;
            R = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Data Input High", test_num);
            reset_dut();
            D = 1;
            S = 0;
            R = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Data Input Low", test_num);
            reset_dut();

            S = 1;
            @(posedge C);
            #1;
            S = 0;
            D = 0;
            R = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Synchronous Behavior Check", test_num);
            reset_dut();
            D = 1;
            S = 0;
            R = 0;
            #2;
            if (Q !== 0) begin
                $display("FAIL: Q changed before clock edge");
            end
            @(posedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Set Priority over Data", test_num);
            reset_dut();
            D = 0;
            S = 1;
            R = 0;
            @(posedge C);
            #1;
            #1;

            check_outputs(1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("DFFSR Testbench");
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
        $dumpvars(0,C, D, R, S, Q);
    end

endmodule
