`timescale 1ns/1ps

module fixed_point_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_adder dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 8'h00; b = 8'h00;
            #10;
            $display("Testcase %0d: Zero Addition", test_num);
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 8'h18; b = 8'h24;
            #10;
            $display("Testcase %0d: Positive Addition (1.5 + 2.25)", test_num);

            #1;


            check_outputs(9'h03C);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 8'hE8; b = 8'hDC;
            #10;
            $display("Testcase %0d: Negative Addition (-1.5 + -2.25)", test_num);

            #1;


            check_outputs(9'h1C4);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 8'h7F; b = 8'h7F;
            #10;
            $display("Testcase %0d: Maximum Positive Range", test_num);

            #1;


            check_outputs(9'h0FE);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 8'h80; b = 8'h80;
            #10;
            $display("Testcase %0d: Maximum Negative Range", test_num);

            #1;


            check_outputs(9'h100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 8'h40; b = 8'hD8;
            #10;
            $display("Testcase %0d: Mixed Sign Result Positive (4.0 - 2.5)", test_num);

            #1;


            check_outputs(9'h018);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            a = 8'hC0; b = 8'h18;
            #10;
            $display("Testcase %0d: Mixed Sign Result Negative (-4.0 + 1.5)", test_num);

            #1;


            check_outputs(9'h1D8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            a = 8'h0C; b = 8'h08;
            #10;
            $display("Testcase %0d: Fractional Carry to Integer", test_num);

            #1;


            check_outputs(9'h014);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_adder Testbench");
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
        input [8:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
