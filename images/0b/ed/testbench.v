`timescale 1ns/1ps

module BoothMultiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [7:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BoothMultiplier dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 3 * 2", test_num);
        A = 4'sb0011;
        B = 4'sb0010;
        #1;

        check_outputs(8'sb0000_0110);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 7 * 7", test_num);
        A = 4'sb0111;
        B = 4'sb0111;
        #1;

        check_outputs(8'sb0011_0001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 5 * -3", test_num);
        A = 4'sb0101;
        B = 4'sb1101;
        #1;

        check_outputs(8'sb1111_0001);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -4 * 6", test_num);
        A = 4'sb1100;
        B = 4'sb0110;
        #1;

        check_outputs(8'sb1110_1000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -2 * -3", test_num);
        A = 4'sb1110;
        B = 4'sb1101;
        #1;

        check_outputs(8'sb0000_0110);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -8 * -8", test_num);
        A = 4'sb1000;
        B = 4'sb1000;
        #1;

        check_outputs(8'sb0100_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 0 * -5", test_num);
        A = 4'sb0000;
        B = 4'sb1011;
        #1;

        check_outputs(8'sb0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: 7 * -8", test_num);
        A = 4'sb0111;
        B = 4'sb1000;
        #1;

        check_outputs(8'sb1100_1000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -1 * -1", test_num);
        A = 4'sb1111;
        B = 4'sb1111;
        #1;

        check_outputs(8'sb0000_0001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: -8 * 1", test_num);
        A = 4'sb1000;
        B = 4'sb0001;
        #1;

        check_outputs(8'sb1111_1000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BoothMultiplier Testbench");
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
        input [7:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
