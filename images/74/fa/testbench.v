`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CI;
    reg DI;
    reg S;
    wire O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CI(CI),
        .DI(DI),
        .S(S),
        .O(O)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Channel 0 (S=00), expect high", test_num);

        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;

        CI = 1; DI = 4'b0001; S = 2'b00;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Channel 1 (S=01), expect high", test_num);
        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;
        CI = 1; DI = 4'b0010; S = 2'b01;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Channel 2 (S=10), expect high", test_num);
        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;
        CI = 1; DI = 4'b0100; S = 2'b10;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Channel 3 (S=11), expect high", test_num);
        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;
        CI = 1; DI = 4'b1000; S = 2'b11;
        #10;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select Channel 1 (S=01), expect low", test_num);
        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;
        CI = 1; DI = 4'b1101; S = 2'b01;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Disable MUX (CI=0), expect output low", test_num);
        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;
        CI = 0; DI = 4'b1111; S = 2'b10;
        #10;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Verify data isolation", test_num);
        CI = 0; DI = 4'b0000; S = 2'b00;
        #5;
        CI = 1; S = 2'b11; DI = 4'b1000;
        #5;
        DI = 4'b1011;
        #10;
        #1;

        check_outputs(1'b1);
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
        input expected_O;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: O=%b",
                         O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: O=%b",
                         expected_O);
                $display("  Got:      O=%b",
                         O);
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
