`timescale 1ns/1ps

module JK_latch_tb;

    // Testbench signals (sequential circuit)
    reg J;
    reg K;
    reg clk;
    wire Q;
    wire Q_bar;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    JK_latch dut (
        .J(J),
        .K(K),
        .clk(clk),
        .Q(Q),
        .Q_bar(Q_bar)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin


            J = 0;
            K = 1;
            #10;

            #5;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Set Operation (J=1, K=0)", test_num);
            J = 1;
            K = 0;
            #10;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin

            J = 1; K = 0; #15;
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Reset Operation (J=0, K=1)", test_num);
            J = 0;
            K = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Operation (J=0, K=0) from Q=0", test_num);
            J = 0;
            K = 0;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            reset_dut();

            J = 1; K = 0; #10;
            test_num = test_num + 1;
            $display("Testcase %03d: Hold Operation (J=0, K=0) from Q=1", test_num);
            J = 0;
            K = 0;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle Operation (0 -> 1)", test_num);
            J = 1;
            K = 1;
            #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            reset_dut();

            J = 1; K = 0; #10;
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle Operation (1 -> 0)", test_num);
            J = 1;
            K = 1;
            #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Latch behavior (Input change while clk=0)", test_num);


            wait(clk === 0);
            J = 1;
            K = 0;
            #2;

            #1;


            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            reset_dut();
            test_num = test_num + 1;
            $display("Testcase %03d: Q_bar validation", test_num);
            J = 1; K = 0; #10;
            if (Q === ~Q_bar) begin
                #1;

                check_outputs(1'b1, 1'b0);
            end else begin
                fail_count = fail_count + 1;
                $display("FAIL: Q_bar is not inverse of Q");
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
        $display("JK_latch Testbench");
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
        input expected_Q_bar;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Q_bar === (expected_Q_bar ^ Q_bar ^ expected_Q_bar)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Q_bar=%b",
                         Q, Q_bar);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Q_bar=%b",
                         expected_Q, expected_Q_bar);
                $display("  Got:      Q=%b, Q_bar=%b",
                         Q, Q_bar);
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
        $dumpvars(0,J, K, clk, Q, Q_bar);
    end

endmodule
