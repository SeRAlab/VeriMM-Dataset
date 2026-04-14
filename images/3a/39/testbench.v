`timescale 1ns/1ps

module gradient_descent_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] alpha;
    reg [15:0] x;
    wire [15:0] new_x;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    gradient_descent dut (
        .alpha(alpha),
        .x(x),
        .new_x(new_x)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple subtraction (no underflow)", test_num);
            x = 16'h0064;
            alpha = 16'h000A;

            #1;


            check_outputs(16'h005A);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero learning rate", test_num);
            x = 16'h1234;
            alpha = 16'h0000;

            #1;


            check_outputs(16'h1234);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: x equals alpha (result zero)", test_num);
            x = 16'h03E8;
            alpha = 16'h03E8;

            #1;


            check_outputs(16'h0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Underflow case (x < alpha)", test_num);
            x = 16'h0005;
            alpha = 16'h000A;

            #1;


            check_outputs(16'hFFFB);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values (Max x, Small alpha)", test_num);
            x = 16'hFFFF;
            alpha = 16'h0001;

            #1;


            check_outputs(16'hFFFE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Boundary values (Zero x, Max alpha)", test_num);
            x = 16'h0000;
            alpha = 16'hFFFF;

            #1;


            check_outputs(16'h0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mid-range values", test_num);
            x = 16'h8000;
            alpha = 16'h0100;

            #1;


            check_outputs(16'h7F00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("gradient_descent Testbench");
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
        input [15:0] expected_new_x;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_new_x === (expected_new_x ^ new_x ^ expected_new_x)) begin
                $display("PASS");
                $display("  Outputs: new_x=%h",
                         new_x);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: new_x=%h",
                         expected_new_x);
                $display("  Got:      new_x=%h",
                         new_x);
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
