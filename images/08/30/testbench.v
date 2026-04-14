`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'b0011; B = 4'b0010;
            $display("Test %0d: Positive * Positive (3 * 2)", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'b0101; B = 4'b1101;
            $display("Test %0d: Positive * Negative (5 * -3)", test_num);
            #1;

            check_outputs(8'hF1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'b1100; B = 4'b0110;
            $display("Test %0d: Negative * Positive (-4 * 6)", test_num);
            #1;

            check_outputs(8'hE8);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'b1110; B = 4'b1101;
            $display("Test %0d: Negative * Negative (-2 * -3)", test_num);
            #1;

            check_outputs(8'h06);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'b0111; B = 4'b0111;
            $display("Test %0d: Max Positive * Max Positive (7 * 7)", test_num);
            #1;

            check_outputs(8'h31);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b1000; B = 4'b0111;
            $display("Test %0d: Min Negative * Max Positive (-8 * 7)", test_num);
            #1;

            check_outputs(8'hC8);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b1000; B = 4'b1000;
            $display("Test %0d: Min Negative * Min Negative (-8 * -8)", test_num);
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'b0000; B = 4'b1000;
            $display("Test %0d: Zero * Negative (0 * -8)", test_num);
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'b1111; B = 4'b1111;
            $display("Test %0d: Negative One * Negative One (-1 * -1)", test_num);
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'b0001; B = 4'b1000;
            $display("Test %0d: Identity Positive * Min Negative (1 * -8)", test_num);
            #1;

            check_outputs(8'hF8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
