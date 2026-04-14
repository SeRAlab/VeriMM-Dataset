`timescale 1ns/1ps

module matrix_inversion_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix;
    wire [15:0] inverted_matrix;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inversion dut (
        .matrix(matrix),
        .inverted_matrix(inverted_matrix)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Determinant Zero", test_num);
        matrix = 16'h1111;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity Matrix", test_num);
        matrix = 16'h1001;
        #1;

        check_outputs(16'h1001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: det = 1", test_num);
        matrix = 16'h3211;
        #1;

        check_outputs(16'h1EF3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: det = -1", test_num);
        matrix = 16'h1121;
        #1;

        check_outputs(16'hF12F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Negative Elements", test_num);
        matrix = 16'h1F01;
        #1;

        check_outputs(16'h1101);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Swap Matrix", test_num);
        matrix = 16'h0110;
        #1;

        check_outputs(16'h0110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inversion Testbench");
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
        input [15:0] expected_inverted_matrix;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inverted_matrix === (expected_inverted_matrix ^ inverted_matrix ^ expected_inverted_matrix)) begin
                $display("PASS");
                $display("  Outputs: inverted_matrix=%h",
                         inverted_matrix);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inverted_matrix=%h",
                         expected_inverted_matrix);
                $display("  Got:      inverted_matrix=%h",
                         inverted_matrix);
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
