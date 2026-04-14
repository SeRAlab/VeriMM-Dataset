`timescale 1ns/1ps

module qr_decomposition_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] input_a;
    reg [1:0] input_b;
    wire [1:0] q1;
    wire [1:0] q2;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    qr_decomposition dut (
        .input_a(input_a),
        .input_b(input_b),
        .q1(q1),
        .q2(q2)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case %0d: Identity Matrix (Orthogonal Inputs)", test_num);
            input_a = 2'b10;
            input_b = 2'b01;

            #1;


            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case %0d: Input B contains Input A", test_num);
            input_a = 2'b10;
            input_b = 2'b11;

            #1;


            check_outputs(2'b10, 2'b01);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case %0d: Reversed Identity", test_num);
            input_a = 2'b01;
            input_b = 2'b10;
            #1;

            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case %0d: Input B contains Input A (Y-axis primary)", test_num);
            input_a = 2'b01;
            input_b = 2'b11;

            #1;


            check_outputs(2'b01, 2'b10);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case %0d: Linearly Dependent (Parallel)", test_num);
            input_a = 2'b11;
            input_b = 2'b11;

            #1;


            check_outputs(2'b11, 2'b00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case %0d: Null Matrix", test_num);
            input_a = 2'b00;
            input_b = 2'b00;
            #1;

            check_outputs(2'b00, 2'b00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case %0d: Input A is Zero", test_num);
            input_a = 2'b00;
            input_b = 2'b11;

            #1;


            check_outputs(2'b00, 2'b11);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case %0d: Input B is Zero", test_num);
            input_a = 2'b10;
            input_b = 2'b00;
            #1;

            check_outputs(2'b10, 2'b00);
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
        input [1:0] expected_q1;
        input [1:0] expected_q2;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_q1 === (expected_q1 ^ q1 ^ expected_q1) &&
                expected_q2 === (expected_q2 ^ q2 ^ expected_q2)) begin
                $display("PASS");
                $display("  Outputs: q1=%h, q2=%h",
                         q1, q2);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: q1=%h, q2=%h",
                         expected_q1, expected_q2);
                $display("  Got:      q1=%h, q2=%h",
                         q1, q2);
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
