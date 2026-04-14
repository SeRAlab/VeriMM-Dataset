`timescale 1ns/1ps

module comparator_2bit_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] a;
    reg [1:0] b;
    wire equal;
    wire greater;
    wire less;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comparator_2bit dut (
        .a(a),
        .b(b),
        .equal(equal),
        .greater(greater),
        .less(less)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 2'b00; b = 2'b00;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 2'b00; b = 2'b01;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 2'b00; b = 2'b10;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 2'b00; b = 2'b11;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 2'b01; b = 2'b00;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 2'b01; b = 2'b01;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 2'b01; b = 2'b10;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 2'b01; b = 2'b11;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 2'b10; b = 2'b00;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 2'b10; b = 2'b01;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            a = 2'b10; b = 2'b10;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            a = 2'b10; b = 2'b11;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 0, 1);
        end
        endtask

    task testcase013;

        begin
            test_num = test_num + 1;
            a = 2'b11; b = 2'b00;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase014;

        begin
            test_num = test_num + 1;
            a = 2'b11; b = 2'b01;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase015;

        begin
            test_num = test_num + 1;
            a = 2'b11; b = 2'b10;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(0, 1, 0);
        end
        endtask

    task testcase016;

        begin
            test_num = test_num + 1;
            a = 2'b11; b = 2'b11;
            $display("Test %0d: a=%b, b=%b", test_num, a, b);
            #1;

            check_outputs(1, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comparator_2bit Testbench");
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
        input expected_equal;
        input expected_greater;
        input expected_less;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_equal === (expected_equal ^ equal ^ expected_equal) &&
                expected_greater === (expected_greater ^ greater ^ expected_greater) &&
                expected_less === (expected_less ^ less ^ expected_less)) begin
                $display("PASS");
                $display("  Outputs: equal=%b, greater=%b, less=%b",
                         equal, greater, less);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: equal=%b, greater=%b, less=%b",
                         expected_equal, expected_greater, expected_less);
                $display("  Got:      equal=%b, greater=%b, less=%b",
                         equal, greater, less);
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
