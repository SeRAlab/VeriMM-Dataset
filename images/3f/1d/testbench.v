`timescale 1ns/1ps

module hazard_detect_mux_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg C;
    reg S0;
    reg S1;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    hazard_detect_mux dut (
        .A(A),
        .B(B),
        .C(C),
        .S0(S0),
        .S1(S1),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A (S1S0 = 00)", test_num);
            A = 1'b1; B = 1'b0; C = 1'b0;
            S1 = 1'b0; S0 = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input B (S1S0 = 01)", test_num);
            A = 1'b0; B = 1'b1; C = 1'b0;
            S1 = 1'b0; S0 = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input C (S1S0 = 10)", test_num);
            A = 1'b0; B = 1'b0; C = 1'b1;
            S1 = 1'b1; S0 = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Input A, Change B and C (No effect)", test_num);
            A = 1'b1; B = 1'b0; C = 1'b0;
            S1 = 1'b0; S0 = 1'b0;
            #5;
            B = 1'b1;
            C = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hazard Check - Transition S 00 -> 01 with A=1, B=1", test_num);


            A = 1'b1; B = 1'b1; C = 1'b0;
            S1 = 1'b0; S0 = 1'b0;
            #10;
            S0 = 1'b1;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Hazard Check - Transition S 01 -> 10 with B=1, C=1", test_num);
            A = 1'b0; B = 1'b1; C = 1'b1;
            S1 = 1'b0; S0 = 1'b1;
            #10;
            S1 = 1'b1; S0 = 1'b0;
            #10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Undefined (S1S0 = 11)", test_num);
            A = 1'b1; B = 1'b1; C = 1'b1;
            S1 = 1'b1; S0 = 1'b1;
            #10;


            #1;



            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Inputs Zero", test_num);
            A = 1'b0; B = 1'b0; C = 1'b0;
            S1 = 1'b0; S0 = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
            S0 = 1'b1;
            #10;
            #1;

            check_outputs(1'b0);
            S1 = 1'b1; S0 = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High-to-Low Transition for A while selected", test_num);
            A = 1'b1; B = 1'b0; C = 1'b0;
            S1 = 1'b0; S0 = 1'b0;
            #10;
            A = 1'b0;
            #10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simultaneous data and select change", test_num);
            A = 1'b1; B = 1'b0; C = 1'b0;
            S1 = 1'b0; S0 = 1'b0;
            #10;

            A = 1'b0; B = 1'b1; S0 = 1'b1;
            #10;
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
        $display("hazard_detect_mux Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        testcase008();
        testcase009();
        testcase010();
        
        
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
