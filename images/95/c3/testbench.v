`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg E;
    reg [7:0] I;
    reg [2:0] S;
    wire Y;
    wire nY;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E(E),
        .I(I),
        .S(S),
        .Y(Y),
        .nY(nY)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Enable high (E=1), output should be LOW regardless of I and S", test_num);
        E = 1;
        I = 8'b11111111;
        S = 3'b000;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Enable high (E=1), different select signal", test_num);
        E = 1;
        I = 8'b11111111;
        S = 3'b101;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Enable low (E=0), select I[0] (value 1)", test_num);
        E = 0;
        I = 8'b00000001;
        S = 3'b000;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Enable low (E=0), select I[0] (value 0)", test_num);
        E = 0;
        I = 8'b11111110;
        S = 3'b000;
        #1;

        check_outputs(0, 1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Enable low (E=0), select I[1] (value 1)", test_num);
        E = 0;
        I = 8'b00000010;
        S = 3'b001;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Enable low (E=0), select I[2] (value 1)", test_num);
        E = 0;
        I = 8'b00000100;
        S = 3'b010;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Enable low (E=0), select I[3] (value 1)", test_num);
        E = 0;
        I = 8'b00001000;
        S = 3'b011;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Enable low (E=0), select I[4] (value 1)", test_num);
        E = 0;
        I = 8'b00010000;
        S = 3'b100;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Enable low (E=0), select I[5] (value 1)", test_num);
        E = 0;
        I = 8'b00100000;
        S = 3'b101;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Enable low (E=0), select I[6] (value 1)", test_num);
        E = 0;
        I = 8'b01000000;
        S = 3'b110;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Enable low (E=0), select I[7] (value 1)", test_num);
        E = 0;
        I = 8'b10000000;
        S = 3'b111;
        #1;

        check_outputs(1, 0);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Enable low (E=0), select I[3] (value 0) with other bits high", test_num);
        E = 0;
        I = 8'b11110111;
        S = 3'b011;
        #1;

        check_outputs(0, 1);
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
        input expected_Y;
        input expected_nY;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y) &&
                expected_nY === (expected_nY ^ nY ^ expected_nY)) begin
                $display("PASS");
                $display("  Outputs: Y=%b, nY=%b",
                         Y, nY);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%b, nY=%b",
                         expected_Y, expected_nY);
                $display("  Got:      Y=%b, nY=%b",
                         Y, nY);
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
