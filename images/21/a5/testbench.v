`timescale 1ns/1ps

module vector_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] S;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_adder dut (
        .A(A),
        .B(B),
        .S(S),
        .overflow(overflow)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero addition (0 + 0)", test_num);
            A = 4'd0;
            B = 4'd0;
            #1;

            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Small sum no overflow (3 + 4)", test_num);
            A = 4'd3;
            B = 4'd4;
            #1;

            check_outputs(5'd7, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Boundary sum no overflow (7 + 8)", test_num);
            A = 4'd7;
            B = 4'd8;
            #1;

            check_outputs(5'd15, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum overflow (8 + 8)", test_num);
            A = 4'd8;
            B = 4'd8;
            #1;

            check_outputs(5'd16, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum overflow (15 + 15)", test_num);
            A = 4'd15;
            B = 4'd15;
            #1;

            check_outputs(5'd30, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit overflow (15 + 1)", test_num);
            A = 4'd15;
            B = 4'd1;
            #1;

            check_outputs(5'd16, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mid-range overflow (10 + 10)", test_num);
            A = 4'd10;
            B = 4'd10;
            #1;

            check_outputs(5'd20, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_adder Testbench");
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
        input [4:0] expected_S;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: S=%h, overflow=%b",
                         S, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, overflow=%b",
                         expected_S, expected_overflow);
                $display("  Got:      S=%h, overflow=%b",
                         S, overflow);
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
