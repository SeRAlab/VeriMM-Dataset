`timescale 1ns/1ps

module xnor_5input_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    wire Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xnor_5input dut (
        .A(A),
        .Y(Y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 0 bits high (Even)", test_num);
            A = 5'b00000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 1 bit high (Odd)", test_num);
            A = 5'b00001;
            #1;

            check_outputs(1'b0);

            test_num = test_num + 1;
            A = 5'b10000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 2 bits high (Even)", test_num);
            A = 5'b00011;
            #1;

            check_outputs(1'b1);

            test_num = test_num + 1;
            A = 5'b10100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 3 bits high (Odd)", test_num);
            A = 5'b00111;
            #1;

            check_outputs(1'b0);

            test_num = test_num + 1;
            A = 5'b11010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 4 bits high (Even)", test_num);
            A = 5'b01111;
            #1;

            check_outputs(1'b1);

            test_num = test_num + 1;
            A = 5'b11101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: 5 bits high (Odd)", test_num);
            A = 5'b11111;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("\nTestcase 007: Walking Bit Test");
            for (i = 0; i < 5; i = i + 1) begin
                test_num = test_num + 1;
                A = (5'b00001 << i);
                #1;

                check_outputs(1'b0);
            end
        end
        endtask

    task testcase008;

        integer i;
        reg [4:0] count_ones;
        integer j;
        begin
            $display("\nTestcase 008: Exhaustive Verification of all 32 states");
            for (i = 0; i < 32; i = i + 1) begin
                test_num = test_num + 1;
                A = i;
                count_ones = 0;
                for (j = 0; j < 5; j = j + 1) begin
                    if (A[j]) count_ones = count_ones + 1;
                end

                #1;


                check_outputs((count_ones % 2 == 0) ? 1'b1 : 1'b0);
            end
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xnor_5input Testbench");
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
