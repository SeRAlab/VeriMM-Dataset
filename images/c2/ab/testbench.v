`timescale 1ns/1ps

module d_latch_tb;

    // Testbench signals (sequential circuit)
    reg D;
    reg GATE;
    reg RESET_B;
    wire Q;
    wire Q_N;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    d_latch dut (
        .D(D),
        .GATE(GATE),
        .RESET_B(RESET_B),
        .Q(Q),
        .Q_N(Q_N)
    );

    // Clock generation (10ns period)
    initial begin
        GATE = 0;
        forever #5 GATE = ~GATE;
    end

        task reset_dut;

        begin
            RESET_B = 0;
            D = 0;
            #15;
            RESET_B = 1;
            #5;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Asynchronous Reset Verification", test_num);
            reset_dut();

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Transparency Mode (GATE=1, D=1)", test_num);
            reset_dut();
            @(posedge GATE);
            D = 1;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Transparency Mode (GATE=1, D=0)", test_num);
            reset_dut();
            @(posedge GATE);
            D = 1;
            #2;
            D = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Latching/Hold Mode (D=1)", test_num);
            reset_dut();
            @(posedge GATE);
            D = 1;
            #2;
            @(negedge GATE);
            #2;
            D = 0;
            #2;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Latching/Hold Mode (D=0)", test_num);
            reset_dut();
            @(posedge GATE);
            D = 0;
            #2;
            @(negedge GATE);
            #2;
            D = 1;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Asynchronous Reset Priority Over GATE/D", test_num);
            reset_dut();
            @(posedge GATE);
            D = 1;
            #2;
            RESET_B = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Asynchronous Reset during Hold Phase", test_num);
            reset_dut();
            @(posedge GATE);
            D = 1;
            #2;
            @(negedge GATE);
            #2;
            RESET_B = 0;
            #2;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("d_latch Testbench");
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
        input expected_Q_N;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_N === (expected_Q_N ^ Q_N ^ expected_Q_N)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_N=%b",
                         Q, Q_N);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_N=%b",
                         expected_Q, expected_Q_N);
                $display("  Got:      Q=%b, Q_N=%b",
                         Q, Q_N);
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
        $dumpvars(0,D, GATE, RESET_B, Q, Q_N);
    end

endmodule
