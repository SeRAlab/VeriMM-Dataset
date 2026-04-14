`timescale 1ns/1ps

module xor4_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg c;
    reg d;
    wire y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor4 dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0000 (Even: 0)", test_num);
            a = 0; b = 0; c = 0; d = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0001 (Odd: 1)", test_num);
            a = 0; b = 0; c = 0; d = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0010 (Odd: 1)", test_num);
            a = 0; b = 0; c = 1; d = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0011 (Even: 2)", test_num);
            a = 0; b = 0; c = 1; d = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0100 (Odd: 1)", test_num);
            a = 0; b = 1; c = 0; d = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0101 (Even: 2)", test_num);
            a = 0; b = 1; c = 0; d = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0110 (Even: 2)", test_num);
            a = 0; b = 1; c = 1; d = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 0111 (Odd: 3)", test_num);
            a = 0; b = 1; c = 1; d = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1000 (Odd: 1)", test_num);
            a = 1; b = 0; c = 0; d = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1001 (Even: 2)", test_num);
            a = 1; b = 0; c = 0; d = 1;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1010 (Even: 2)", test_num);
            a = 1; b = 0; c = 1; d = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1011 (Odd: 3)", test_num);
            a = 1; b = 0; c = 1; d = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1100 (Even: 2)", test_num);
            a = 1; b = 1; c = 0; d = 0;
            #1;

            check_outputs(0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1101 (Odd: 3)", test_num);
            a = 1; b = 1; c = 0; d = 1;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1110 (Odd: 3)", test_num);
            a = 1; b = 1; c = 1; d = 0;
            #1;

            check_outputs(1);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Inputs 1111 (Even: 4)", test_num);
            a = 1; b = 1; c = 1; d = 1;
            #1;

            check_outputs(0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor4 Testbench");
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%b",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%b",
                         expected_y);
                $display("  Got:      y=%b",
                         y);
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
