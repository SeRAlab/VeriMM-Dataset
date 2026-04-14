`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg [3:0] c;
    wire [3:0] carry;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .a(a),
        .b(b),
        .c(c),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            a = 4'b0000;
            b = 4'b0000;
            c = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            a = 4'b0001;
            b = 4'b0001;
            c = 4'b0001;
            #1;

            check_outputs(4'b0001, 4'b0001);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            a = 4'b1010;
            b = 4'b0101;
            c = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            a = 4'b1111;
            b = 4'b1111;
            c = 4'b1111;
            #1;

            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            a = 4'b1100;
            b = 4'b1010;
            c = 4'b1001;
            #1;

            check_outputs(4'b1000, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            a = 4'b0101;
            b = 4'b1010;
            c = 4'b1111;
            #1;

            check_outputs(4'b1111, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            a = 4'b1000;
            b = 4'b0100;
            c = 4'b1100;
            #1;

            check_outputs(4'b1000, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            a = 4'b0100;
            b = 4'b0100;
            c = 4'b0000;
            #1;

            check_outputs(4'b0100, 4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            a = 4'b1011;
            b = 4'b0111;
            c = 4'b1101;
            #1;

            check_outputs(4'b1111, 4'b0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            a = 4'b1111;
            b = 4'b0000;
            c = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_save_adder Testbench");
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
        input [3:0] expected_carry;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry === (expected_carry ^ carry ^ expected_carry) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry=%h, sum=%h",
                         carry, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry=%h, sum=%h",
                         expected_carry, expected_sum);
                $display("  Got:      carry=%h, sum=%h",
                         carry, sum);
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
