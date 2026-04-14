`timescale 1ns/1ps

module comparator_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire A_eq;
    wire A_gt;
    wire A_lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_8bit dut (
        .A(A),
        .B(B),
        .A_eq(A_eq),
        .A_gt(A_gt),
        .A_lt(A_lt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=0 (Equal)", test_num);
            A = 8'd0;
            B = 8'd0;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=255, B=255 (Equal max)", test_num);
            A = 8'd255;
            B = 8'd255;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=170, B=170 (Equal pattern)", test_num);
            A = 8'hAA;
            B = 8'hAA;
            #1;

            check_outputs(1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=1, B=0 (A > B)", test_num);
            A = 8'd1;
            B = 8'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=255, B=0 (A > B max)", test_num);
            A = 8'd255;
            B = 8'd0;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=128, B=127 (A > B edge)", test_num);
            A = 8'd128;
            B = 8'd127;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=1 (A < B)", test_num);
            A = 8'd0;
            B = 8'd1;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=0, B=255 (A < B max)", test_num);
            A = 8'd0;
            B = 8'd255;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=127, B=128 (A < B edge)", test_num);
            A = 8'd127;
            B = 8'd128;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=255, B=254 (A > B LSB diff)", test_num);
            A = 8'b1111_1111;
            B = 8'b1111_1110;
            #1;

            check_outputs(1'b0, 1'b1, 1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: A=85, B=170 (A < B pattern)", test_num);
            A = 8'h55;
            B = 8'hAA;
            #1;

            check_outputs(1'b0, 1'b0, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_8bit Testbench");
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
        testcase011();
        
        
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
        input expected_A_eq;
        input expected_A_gt;
        input expected_A_lt;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A_eq === (expected_A_eq ^ A_eq ^ expected_A_eq) &&
                expected_A_gt === (expected_A_gt ^ A_gt ^ expected_A_gt) &&
                expected_A_lt === (expected_A_lt ^ A_lt ^ expected_A_lt)) begin
                $display("PASS");
                $display("  Outputs: A_eq=%b, A_gt=%b, A_lt=%b",
                         A_eq, A_gt, A_lt);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_eq=%b, A_gt=%b, A_lt=%b",
                         expected_A_eq, expected_A_gt, expected_A_lt);
                $display("  Got:      A_eq=%b, A_gt=%b, A_lt=%b",
                         A_eq, A_gt, A_lt);
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
