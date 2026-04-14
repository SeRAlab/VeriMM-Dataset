`timescale 1ns/1ps

module data_forwarding_mux_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] D;
    reg F;
    reg [1:0] S;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    data_forwarding_mux dut (
        .D(D),
        .F(F),
        .S(S),
        .Y(Y)
    );
    task perform_test;

        input [3:0] d_in;
        input [1:0] s_in;
        input f_in;
        input expected_y;
        begin
            D = d_in;
            S = s_in;
            F = f_in;
            #1;

            check_outputs(expected_y);
        end
        endtask

    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Mux Select D0 (No Match)", test_num);

            perform_test(4'b1111, 2'b00, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Mux Select D3 (No Match)", test_num);

            perform_test(4'b0000, 2'b11, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding via D0 (S=10)", test_num);

            perform_test(4'b1110, 2'b10, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding via D1 (S=00)", test_num);

            perform_test(4'b1101, 2'b00, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding via D2 (S=11)", test_num);

            perform_test(4'b1011, 2'b11, 1'b0, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding via D3 (S=01)", test_num);

            perform_test(4'b0111, 2'b01, 1'b0, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding via Multiple Matches (D0, D2)", test_num);

            perform_test(4'b0101, 2'b01, 1'b1, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Forwarding when Selected Input matches F", test_num);

            perform_test(4'b1000, 2'b11, 1'b1, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All inputs match F", test_num);

            perform_test(4'b1111, 2'b10, 1'b1, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Normal Mux Select D2 (No Match)", test_num);


            perform_test(4'b1011, 2'b00, 1'b0, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("data_forwarding_mux Testbench");
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
