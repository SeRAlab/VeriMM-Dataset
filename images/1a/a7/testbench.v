`timescale 1ns/1ps

module comparator_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire A_eq;
    wire A_gt;
    wire A_lt;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_16bit dut (
        .A(A),
        .B(B),
        .A_eq(A_eq),
        .A_gt(A_gt),
        .A_lt(A_lt)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=0", test_num);
            A = 16'h0000;
            B = 16'h0000;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=FFFF, B=FFFF", test_num);
            A = 16'hFFFF;
            B = 16'hFFFF;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1, B=0", test_num);
            A = 16'h0001;
            B = 16'h0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0, B=1", test_num);
            A = 16'h0000;
            B = 16'h0001;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=FFFF, B=0000", test_num);
            A = 16'hFFFF;
            B = 16'h0000;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=0000, B=FFFF", test_num);
            A = 16'h0000;
            B = 16'hFFFF;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=8000, B=7FFF", test_num);
            A = 16'h8000;
            B = 16'h7FFF;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=7FFF, B=8000", test_num);
            A = 16'h7FFF;
            B = 16'h8000;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=1234, B=1234", test_num);
            A = 16'h1234;
            B = 16'h1234;
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=AAAA, B=5555", test_num);
            A = 16'hAAAA;
            B = 16'h5555;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=5555, B=AAAA", test_num);
            A = 16'h5555;
            B = 16'hAAAA;
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: A=5551, B=5550", test_num);
            A = 16'h5551;
            B = 16'h5550;
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_16bit Testbench");
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
        testcase012();
        
        
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
