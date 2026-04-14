`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] matrix;
    wire [3:0] Q;
    wire [3:0] R;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .matrix(matrix),
        .Q(Q),
        .R(R)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Identity Matrix", test_num);
            matrix = 4'b1001;
            #1;

            check_outputs(4'b1001, 4'b1001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Column Swap (Orthogonal)", test_num);
            matrix = 4'b0110;
            #1;

            check_outputs(4'b0110, 4'b1001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Upper Triangular", test_num);
            matrix = 4'b1011;
            #1;

            check_outputs(4'b1001, 4'b1011);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero Matrix", test_num);
            matrix = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Linearly Dependent Columns", test_num);
            matrix = 4'b1010;
            #1;

            check_outputs(4'b1000, 4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single Column", test_num);
            matrix = 4'b0100;
            #1;

            check_outputs(4'b0100, 4'b1000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("qr_decomposition Testbench");
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
        input [3:0] expected_Q;
        input [3:0] expected_R;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_R === (expected_R ^ R ^ expected_R)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, R=%h",
                         Q, R);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, R=%h",
                         expected_Q, expected_R);
                $display("  Got:      Q=%h, R=%h",
                         Q, R);
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
