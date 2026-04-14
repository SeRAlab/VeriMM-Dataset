`timescale 1ns/1ps

module binary_subtractor_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] a;
    reg [2:0] b;
    wire borrow_out;
    wire [2:0] difference;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_subtractor dut (
        .a(a),
        .b(b),
        .borrow_out(borrow_out),
        .difference(difference)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero subtraction (0 - 0)", test_num);
            a = 3'b000;
            b = 3'b000;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple subtraction without borrow (5 - 2)", test_num);
            a = 3'b101;
            b = 3'b010;
            #1;

            check_outputs(1'b0, 3'b011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtraction with borrow (2 - 5)", test_num);
            a = 3'b010;
            b = 3'b101;
            #1;

            check_outputs(1'b1, 3'b101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Subtracting from zero (0 - 1)", test_num);
            a = 3'b000;
            b = 3'b001;
            #1;

            check_outputs(1'b1, 3'b111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max values subtraction (7 - 7)", test_num);
            a = 3'b111;
            b = 3'b111;
            #1;

            check_outputs(1'b0, 3'b000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value minus zero (7 - 0)", test_num);
            a = 3'b111;
            b = 3'b000;
            #1;

            check_outputs(1'b0, 3'b111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Smallest positive difference (4 - 3)", test_num);
            a = 3'b100;
            b = 3'b011;
            #1;

            check_outputs(1'b0, 3'b001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large borrow (1 - 7)", test_num);
            a = 3'b001;
            b = 3'b111;
            #1;

            check_outputs(1'b1, 3'b010);
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
        input expected_borrow_out;
        input [2:0] expected_difference;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_borrow_out === (expected_borrow_out ^ borrow_out ^ expected_borrow_out) &&
                expected_difference === (expected_difference ^ difference ^ expected_difference)) begin
                $display("PASS");
                $display("  Outputs: borrow_out=%b, difference=%h",
                         borrow_out, difference);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: borrow_out=%b, difference=%h",
                         expected_borrow_out, expected_difference);
                $display("  Got:      borrow_out=%b, difference=%h",
                         borrow_out, difference);
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
