`timescale 1ns/1ps

module master_slave_d_latch_tb;

    // Testbench signals (combinational circuit)
    reg D;
    reg E;
    wire Q;
    wire Qn;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    master_slave_d_latch dut (
        .D(D),
        .E(E),
        .Q(Q),
        .Qn(Qn)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Reset and Initialize to 0", test_num);

            E = 0; D = 1; #10;
            E = 1; D = 0; #10;
            E = 0;        #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Write 1 (Master-Slave transition)", test_num);

            E = 1; D = 0; #10; E = 0; #10;


            E = 1; D = 1; #10;
            E = 0;        #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Data change while E is low (Hold check)", test_num);

            E = 1; D = 1; #10; E = 0; #10;


            D = 0; #10;
            D = 1; #10;
            D = 0; #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Master captures last value before E falls", test_num);

            E = 1; D = 0; #10; E = 0; #10;

            E = 1;
            D = 1; #10;
            D = 0; #10;
            D = 1; #10;
            E = 0; #10;
            #1;

            check_outputs(1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Toggle logic (1 to 0)", test_num);

            E = 1; D = 1; #10; E = 0; #10;


            E = 1; D = 0; #10;
            E = 0; #10;
            #1;

            check_outputs(1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Rapid E pulses with D static", test_num);

            E = 1; D = 0; #10; E = 0; #10;

            D = 1;
            E = 1; #5; E = 0; #5;
            E = 1; #5; E = 0; #5;
            #1;

            check_outputs(1'b1, 1'b0);
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
        input expected_Qn;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_Qn === (expected_Qn ^ Qn ^ expected_Qn)) begin
                $display("PASS");
                $display("  Outputs: Q=%b, Qn=%b",
                         Q, Qn);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%b, Qn=%b",
                         expected_Q, expected_Qn);
                $display("  Got:      Q=%b, Qn=%b",
                         Q, Qn);
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

endmodule
