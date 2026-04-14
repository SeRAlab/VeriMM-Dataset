`timescale 1ns/1ps

module jk_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg J;
    reg K;
    wire Q;
    wire QN;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    jk_latch dut (
        .CLK(CLK),
        .J(J),
        .K(K),
        .Q(Q),
        .QN(QN)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            J = 0;
            K = 1;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Test %0d: Set Operation (J=1, K=0)", test_num);
            J = 1;
            K = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            reset_dut();

            J = 1; K = 0; @(posedge CLK); #1;

            test_num = 2;
            $display("Test %0d: Reset Operation (J=0, K=1)", test_num);
            J = 0;
            K = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();

            J = 1; K = 0; @(posedge CLK); #1;

            test_num = 3;
            $display("Test %0d: Hold Operation from Set (J=0, K=0)", test_num);
            J = 0;
            K = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Test %0d: Hold Operation from Reset (J=0, K=0)", test_num);
            J = 0;
            K = 0;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Test %0d: Toggle Operation (J=1, K=1, 0 -> 1)", test_num);
            J = 1;
            K = 1;
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Test %0d: Double Toggle Operation (J=1, K=1, two cycles)", test_num);
            J = 1;
            K = 1;
            @(posedge CLK);
            @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = 7;
            $display("Test %0d: Multiple Toggles (5 cycles)", test_num);
            J = 1;
            K = 1;
            repeat(5) @(posedge CLK);
            #1;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = 8;
            $display("Test %0d: Complement Output Check (QN)", test_num);
            J = 1;
            K = 0;
            @(posedge CLK);
            #1;
            if (Q !== ~QN) begin
                $display("FAIL: Q and QN are not complements!");
                fail_count = fail_count + 1;
            end else begin
                #1;

                check_outputs(1'b1, 1'b0);
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
        $display("jk_latch Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        
        
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
        input expected_QN;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_QN === (expected_QN ^ QN ^ expected_QN)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, QN=%b",
                         Q, QN);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, QN=%b",
                         expected_Q, expected_QN);
                $display("  Got:      Q=%b, QN=%b",
                         Q, QN);
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
        $dumpvars(0,CLK, J, K, Q, QN);
    end

endmodule
