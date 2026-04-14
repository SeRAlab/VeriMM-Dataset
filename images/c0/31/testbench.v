`timescale 1ns/1ps

module operator_B_tb;

    // Testbench signals (combinational circuit)
    reg G;
    reg G1;
    reg P;
    reg P1;
    wire Go;
    wire Po;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    operator_B dut (
        .G(G),
        .G1(G1),
        .P(P),
        .P1(P1),
        .Go(Go),
        .Po(Po)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %03d: All inputs zero", test_num);
        P = 0; G = 0; P1 = 0; G1 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %03d: Test Propagate logic (P=1, P1=1)", test_num);
        P = 1; G = 0; P1 = 1; G1 = 0;
        #1;

        check_outputs(1'b0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %03d: Test Generate via G input", test_num);
        P = 0; G = 1; P1 = 0; G1 = 0;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %03d: Test Generate via propagation (P=1, G1=1)", test_num);
        P = 1; G = 0; P1 = 0; G1 = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %03d: Block propagation of G1 (P=0, G1=1)", test_num);
        P = 0; G = 0; P1 = 1; G1 = 1;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %03d: All inputs high", test_num);
        P = 1; G = 1; P1 = 1; G1 = 1;
        #1;

        check_outputs(1'b1, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %03d: G high, P low", test_num);
        P = 0; G = 1; P1 = 1; G1 = 1;
        #1;

        check_outputs(1'b1, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %03d: P high, P1 low", test_num);
        P = 1; G = 0; P1 = 0; G1 = 0;
        #1;

        check_outputs(1'b0, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("operator_B Testbench");
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
        input expected_Go;
        input expected_Po;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Go === (expected_Go ^ Go ^ expected_Go) &&
                expected_Po === (expected_Po ^ Po ^ expected_Po)) begin
                $display("PASS");
                $display("  Outputs: Go=%b, Po=%b",
                         Go, Po);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Go=%b, Po=%b",
                         expected_Go, expected_Po);
                $display("  Got:      Go=%b, Po=%b",
                         Go, Po);
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
