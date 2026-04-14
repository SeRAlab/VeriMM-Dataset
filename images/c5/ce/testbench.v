`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .A(A),
        .B(B),
        .Z(Z)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Basic addition (0 + 0 = 0)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition sum = 9 (4 + 5 = 9)", test_num);
            A = 4'd4;
            B = 4'd5;
            #1;

            check_outputs(4'd9);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary condition sum = 10 (5 + 5 = 0)", test_num);
            A = 4'd5;
            B = 4'd5;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sum greater than 9 (8 + 7 = 15 -> 5)", test_num);
            A = 4'd8;
            B = 4'd7;
            #1;

            check_outputs(4'd5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Inputs with large values (15 + 1 = 16 -> 6)", test_num);
            A = 4'd15;
            B = 4'd1;
            #1;

            check_outputs(4'd6);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum possible sum (15 + 15 = 30 -> 0)", test_num);
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sum equals 20 (10 + 10 = 20 -> 0)", test_num);
            A = 4'd10;
            B = 4'd10;
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sum slightly above 20 (12 + 9 = 21 -> 1)", test_num);
            A = 4'd12;
            B = 4'd9;
            #1;

            check_outputs(4'd1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [3:0] expected_Z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Z === (expected_Z ^ Z ^ expected_Z)) begin
                $display("PASS");
                $display("  Outputs: Z=%h",
                         Z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Z=%h",
                         expected_Z);
                $display("  Got:      Z=%h",
                         Z);
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
