`timescale 1ns/1ps

module matrix_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] matrix_a;
    reg [7:0] matrix_b;
    wire [15:0] matrix_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    matrix_multiplier dut (
        .matrix_a(matrix_a),
        .matrix_b(matrix_b),
        .matrix_out(matrix_out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Matrix Multiplication", test_num);
        matrix_a = 8'h00;
        matrix_b = 8'h00;
        #1;

        check_outputs(16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Matrix (A * I = A)", test_num);



        matrix_a = 8'hE4;
        matrix_b = 8'h41;
        #1;

        check_outputs(16'h3210);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Ones Matrix", test_num);


        matrix_a = 8'h55;
        matrix_b = 8'h55;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Matrix Scaling (A * 2I)", test_num);




        matrix_a = 8'h19;
        matrix_b = 8'h82;
        #1;

        check_outputs(16'h0242);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Inputs / Truncation Check", test_num);



        matrix_a = 8'hFF;
        matrix_b = 8'hFF;
        #1;

        check_outputs(16'h2222);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complex Mix", test_num);








        matrix_a = 8'h59;
        matrix_b = 8'h86;
        #1;

        check_outputs(16'h3252);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("matrix_multiplier Testbench");
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
        input [15:0] expected_matrix_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_matrix_out === (expected_matrix_out ^ matrix_out ^ expected_matrix_out)) begin
                $display("PASS");
                $display("  Outputs: matrix_out=%h",
                         matrix_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: matrix_out=%h",
                         expected_matrix_out);
                $display("  Got:      matrix_out=%h",
                         matrix_out);
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
