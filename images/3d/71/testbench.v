`timescale 1ns/1ps

module five_input_nor_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg D;
    reg E;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    five_input_nor dut (
        .A(A),
        .B(B),
        .C(C),
        .D(D),
        .E(E),
        .Y(Y)
    );
    task testcase001;

        begin
            $display("Test Case 001: All inputs LOW (Expecting Y=1)");
            A = 0; B = 0; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            $display("Test Case 002: Only A HIGH (Expecting Y=0)");
            A = 1; B = 0; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            $display("Test Case 003: Only B HIGH (Expecting Y=0)");
            A = 0; B = 1; C = 0; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            $display("Test Case 004: Only C HIGH (Expecting Y=0)");
            A = 0; B = 0; C = 1; D = 0; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            $display("Test Case 005: Only D HIGH (Expecting Y=0)");
            A = 0; B = 0; C = 0; D = 1; E = 0;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            $display("Test Case 006: Only E HIGH (Expecting Y=0)");
            A = 0; B = 0; C = 0; D = 0; E = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            $display("Test Case 007: Multiple inputs HIGH (A, C, E) (Expecting Y=0)");
            A = 1; B = 0; C = 1; D = 0; E = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            $display("Test Case 008: All inputs HIGH (Expecting Y=0)");
            A = 1; B = 1; C = 1; D = 1; E = 1;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("five_input_nor Testbench");
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
        input expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%b",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b",
                         expected_Y);
                $display("  Got:      Y=%b",
                         Y);
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
