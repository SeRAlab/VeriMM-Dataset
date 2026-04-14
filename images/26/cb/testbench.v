`timescale 1ns/1ps

module matrix_inverse_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] matrix;
    wire [15:0] inverse;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_inverse dut (
        .matrix(matrix),
        .inverse(inverse),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: Identity Matrix", test_num);
        matrix = 16'h1001;
        #1;

        check_outputs(16'h1001, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Determinant Zero (1,2,2,4)", test_num);
        matrix = 16'h1224;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Determinant 1 (2,1,1,1)", test_num);
        matrix = 16'h2111;
        #1;

        check_outputs(16'h1FF2, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Determinant -1 (1,1,1,0)", test_num);
        matrix = 16'h1110;
        #1;

        check_outputs(16'h011F, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: All Zeros", test_num);
        matrix = 16'h0000;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: Negative Identity", test_num);
        matrix = 16'hF00F;
        #1;

        check_outputs(16'hF00F, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: Zero Row (0,0,1,1)", test_num);
        matrix = 16'h0011;
        #1;

        check_outputs(16'h0000, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_inverse Testbench");
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
        input [15:0] expected_inverse;
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_inverse === (expected_inverse ^ inverse ^ expected_inverse) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: inverse=%h, valid=%b",
                         inverse, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: inverse=%h, valid=%b",
                         expected_inverse, expected_valid);
                $display("  Got:      inverse=%h, valid=%b",
                         inverse, valid);
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
