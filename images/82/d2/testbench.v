`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg r;
    reg [3:0] s;
    wire S3;
    wire S4;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .r(r),
        .s(s),
        .S3(S3),
        .S4(S4)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: State W, r=0 -> Next: State X (S3=0, S4=0)", test_num);

        s = 4'b0001;
        r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: State W, r=1 -> Next: State Y (S3=1, S4=0)", test_num);
        s = 4'b0001;
        r = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: State X, r=0 -> Next: State W (S3=0, S4=0)", test_num);
        s = 4'b0010;
        r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: State X, r=1 -> Next: State Z (S3=0, S4=1)", test_num);
        s = 4'b0010;
        r = 1;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: State Y, r=0 -> Next: State Z (S3=0, S4=1)", test_num);
        s = 4'b0100;
        r = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: State Y, r=1 -> Next: State W (S3=0, S4=0)", test_num);
        s = 4'b0100;
        r = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: State Z, r=0 -> Next: State X (S3=0, S4=0)", test_num);
        s = 4'b1000;
        r = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: State Z, r=1 -> Next: State Y (S3=1, S4=0)", test_num);
        s = 4'b1000;
        r = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input expected_S3;
        input expected_S4;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S3 === (expected_S3 ^ S3 ^ expected_S3) &&
                expected_S4 === (expected_S4 ^ S4 ^ expected_S4)) begin
                $display("PASS");
                $display("  Outputs: S3=%b, S4=%b",
                         S3, S4);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S3=%b, S4=%b",
                         expected_S3, expected_S4);
                $display("  Got:      S3=%b, S4=%b",
                         S3, S4);
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
