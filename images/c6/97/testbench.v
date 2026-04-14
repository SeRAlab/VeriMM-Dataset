`timescale 1ns/1ps

module combinational_circuit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] A1A2;
    reg [1:0] B1B2;
    reg [1:0] C1C2;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    combinational_circuit dut (
        .A1A2(A1A2),
        .B1B2(B1B2),
        .C1C2(C1C2),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: C1C2 is 0 (NOT C1C2 should be true)", test_num);
            A1A2 = 2'b00;
            B1B2 = 2'b00;
            C1C2 = 2'b00;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All inputs non-zero", test_num);
            A1A2 = 2'b01;
            B1B2 = 2'b10;
            C1C2 = 2'b11;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1A2 is 0, C1C2 is non-zero", test_num);
            A1A2 = 2'b00;
            B1B2 = 2'b11;
            C1C2 = 2'b01;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: B1B2 is 0, C1C2 is non-zero", test_num);
            A1A2 = 2'b10;
            B1B2 = 2'b00;
            C1C2 = 2'b10;

            #1;


            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: A1A2 and B1B2 are non-zero, C1C2 is 0", test_num);
            A1A2 = 2'b11;
            B1B2 = 2'b11;
            C1C2 = 2'b00;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values, C1C2 non-zero", test_num);
            A1A2 = 2'b11;
            B1B2 = 2'b11;
            C1C2 = 2'b11;

            #1;


            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Only B1B2 is non-zero, C1C2 non-zero", test_num);
            A1A2 = 2'b00;
            B1B2 = 2'b01;
            C1C2 = 2'b10;

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
        $display("combinational_circuit Testbench");
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
