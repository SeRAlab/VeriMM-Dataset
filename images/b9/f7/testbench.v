`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] x;
    reg [2:0] y;
    wire [2:0] diff;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .x(x),
        .y(y),
        .diff(diff)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Subtraction (0 - 0)", test_num);
        x = 3'b000;
        y = 3'b000;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple Subtraction (5 - 2)", test_num);
        x = 3'b101;
        y = 3'b010;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Subtraction (3 - 3)", test_num);
        x = 3'b011;
        y = 3'b011;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Wrap-around Subtraction (2 - 5)", test_num);
        x = 3'b010;
        y = 3'b101;

        #1;


        check_outputs(3'b101);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Subtracting Zero (7 - 0)", test_num);
        x = 3'b111;
        y = 3'b000;
        #1;

        check_outputs(3'b111);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Result is -1 (0 - 1)", test_num);
        x = 3'b000;
        y = 3'b001;

        #1;


        check_outputs(3'b111);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max values (7 - 7)", test_num);
        x = 3'b111;
        y = 3'b111;
        #1;

        check_outputs(3'b000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Boundary case (4 - 1)", test_num);
        x = 3'b100;
        y = 3'b001;
        #1;

        check_outputs(3'b011);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Underflow boundary (0 - 7)", test_num);
        x = 3'b000;
        y = 3'b111;

        #1;


        check_outputs(3'b001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Random bits (6 - 3)", test_num);
        x = 3'b110;
        y = 3'b011;
        #1;

        check_outputs(3'b011);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_subtractor Testbench");
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
        input [2:0] expected_diff;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_diff === (expected_diff ^ diff ^ expected_diff)) begin
                $display("PASS");
                $display("  Outputs: diff=%h",
                         diff);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: diff=%h",
                         expected_diff);
                $display("  Got:      diff=%h",
                         diff);
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
