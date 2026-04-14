`timescale 1ns/1ps

module my_full_adder_tb;

    // Testbench signals (combinational circuit)
    reg A;
    reg B;
    reg CIN;
    wire COUT;
    wire SUM;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    my_full_adder dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .COUT(COUT),
        .SUM(SUM)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 1'b0; B = 1'b0; CIN = 1'b0;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 1'b0; B = 1'b0; CIN = 1'b1;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 1'b0; B = 1'b1; CIN = 1'b0;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 1'b0; B = 1'b1; CIN = 1'b1;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 1'b1; B = 1'b0; CIN = 1'b0;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 1'b1; B = 1'b0; CIN = 1'b1;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 1'b1; B = 1'b1; CIN = 1'b0;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 1'b1; B = 1'b1; CIN = 1'b1;
        $display("Testcase %0d: A=%b, B=%b, CIN=%b", test_num, A, B, CIN);
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("my_full_adder Testbench");
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
        input expected_COUT;
        input expected_SUM;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_SUM === (expected_SUM ^ SUM ^ expected_SUM)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, SUM=%b",
                         COUT, SUM);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, SUM=%b",
                         expected_COUT, expected_SUM);
                $display("  Got:      COUT=%b, SUM=%b",
                         COUT, SUM);
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
