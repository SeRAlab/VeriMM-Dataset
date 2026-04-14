`timescale 1ns/1ps

module logistic_regression_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] x;
    wire [3:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logistic_regression dut (
        .x(x),
        .y(y)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: x=000 (Sum=0)", test_num);
        x = 3'b000;
        #1;

        check_outputs(4'd8);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: x=001 (Sum=2)", test_num);
        x = 3'b001;
        #1;

        check_outputs(4'd13);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: x=010 (Sum=3)", test_num);
        x = 3'b010;
        #1;

        check_outputs(4'd14);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: x=011 (Sum=5)", test_num);
        x = 3'b011;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: x=100 (Sum=5)", test_num);
        x = 3'b100;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: x=101 (Sum=7)", test_num);
        x = 3'b101;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: x=110 (Sum=8)", test_num);
        x = 3'b110;
        #1;

        check_outputs(4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: x=111 (Sum=10)", test_num);
        x = 3'b111;
        #1;

        check_outputs(4'd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logistic_regression Testbench");
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
        input [3:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
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
