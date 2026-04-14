`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] num1;
    reg [7:0] num2;
    wire [8:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .num1(num1),
        .num2(num2),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition (0 + 0)", test_num);
            num1 = 8'h00;
            num2 = 8'h00;
            #1;

            check_outputs(9'h000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Minimum values (1 + 1)", test_num);
            num1 = 8'h01;
            num2 = 8'h01;
            #1;

            check_outputs(9'h002);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary value no carry (127 + 127)", test_num);
            num1 = 8'd127;
            num2 = 8'd127;
            #1;

            check_outputs(9'd254);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry out check (255 + 1)", test_num);
            num1 = 8'hFF;
            num2 = 8'h01;
            #1;

            check_outputs(9'h100);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum sum (255 + 255)", test_num);
            num1 = 8'hFF;
            num2 = 8'hFF;
            #1;

            check_outputs(9'h1FE);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0xAA + 0x55)", test_num);
            num1 = 8'hAA;
            num2 = 8'h55;
            #1;

            check_outputs(9'h0FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range values (123 + 45)", test_num);
            num1 = 8'd123;
            num2 = 8'd45;
            #1;

            check_outputs(9'd168);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
