`timescale 1ns/1ps

module decoder_2to4_tb;

    // Testbench signals (combinational circuit)
    reg a;
    reg b;
    reg en;
    wire y0;
    wire y1;
    wire y2;
    wire y3;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    decoder_2to4 dut (
        .a(a),
        .b(b),
        .en(en),
        .y0(y0),
        .y1(y1),
        .y2(y2),
        .y3(y3)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable=0, a=0, b=0", test_num);
            en = 0; a = 0; b = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable=0, a=1, b=1", test_num);
            en = 0; a = 1; b = 1;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable=1, a=0, b=0 -> Expect y0=1", test_num);
            en = 1; a = 0; b = 0;
            #1;

            check_outputs(1, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable=1, a=0, b=1 -> Expect y1=1", test_num);
            en = 1; a = 0; b = 1;
            #1;

            check_outputs(0, 1, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable=1, a=1, b=0 -> Expect y2=1", test_num);
            en = 1; a = 1; b = 0;
            #1;

            check_outputs(0, 0, 1, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Enable=1, a=1, b=1 -> Expect y3=1", test_num);
            en = 1; a = 1; b = 1;
            #1;

            check_outputs(0, 0, 0, 1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Disabling while input is 11", test_num);
            en = 1; a = 1; b = 1;
            #1;
            en = 0;
            #1;

            check_outputs(0, 0, 0, 0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("decoder_2to4 Testbench");
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
        input expected_y0;
        input expected_y1;
        input expected_y2;
        input expected_y3;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y0 === (expected_y0 ^ y0 ^ expected_y0) &&
                expected_y1 === (expected_y1 ^ y1 ^ expected_y1) &&
                expected_y2 === (expected_y2 ^ y2 ^ expected_y2) &&
                expected_y3 === (expected_y3 ^ y3 ^ expected_y3)) begin
                $display("PASS");
                $display("  Outputs: y0=%b, y1=%b, y2=%b, y3=%b",
                         y0, y1, y2, y3);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y0=%b, y1=%b, y2=%b, y3=%b",
                         expected_y0, expected_y1, expected_y2, expected_y3);
                $display("  Got:      y0=%b, y1=%b, y2=%b, y3=%b",
                         y0, y1, y2, y3);
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
