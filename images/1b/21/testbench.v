`timescale 1ns/1ps

module jk_latch_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg J;
    reg K;
    wire Q;
    wire notQ;

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
        .notQ(notQ)
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
            #2;
        end
        endtask
    task testcase001;

        begin
            $display("Running Testcase 001: Set Function (J=1, K=0)");
            test_num = 1;
            reset_dut();

            J = 1;
            K = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            $display("Running Testcase 002: Reset Function (J=0, K=1)");
            test_num = 2;
            reset_dut();


            J = 1; K = 0;
            @(posedge CLK);
            #2;


            J = 0; K = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            $display("Running Testcase 003: Hold Function (J=0, K=0) from High");
            test_num = 3;
            reset_dut();


            J = 1; K = 0;
            @(posedge CLK);
            #2;


            J = 0; K = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Running Testcase 004: Hold Function (J=0, K=0) from Low");
            test_num = 4;
            reset_dut();


            J = 0; K = 0;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            $display("Running Testcase 005: Toggle Function (J=1, K=1) 0->1");
            test_num = 5;
            reset_dut();

            J = 1; K = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Running Testcase 006: Toggle Function (J=1, K=1) 1->0");
            test_num = 6;
            reset_dut();


            J = 1; K = 0;
            @(posedge CLK);
            #2;


            J = 1; K = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            $display("Running Testcase 007: Consecutive Toggles");
            test_num = 7;
            reset_dut();

            J = 1; K = 1;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Running Testcase 008: No change on falling edge");
            test_num = 8;
            reset_dut();

            J = 1; K = 0;
            @(negedge CLK);
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
        input expected_notQ;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_notQ === (expected_notQ ^ notQ ^ expected_notQ)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, notQ=%b",
                         Q, notQ);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, notQ=%b",
                         expected_Q, expected_notQ);
                $display("  Got:      Q=%b, notQ=%b",
                         Q, notQ);
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
        $dumpvars(0,CLK, J, K, Q, notQ);
    end

endmodule
