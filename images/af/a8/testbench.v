`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    reg c_in;
    wire [3:0] carry_ahead;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c_in(c_in),
        .carry_ahead(carry_ahead),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All inputs zero", test_num);
            a = 4'b0000; b = 4'b0000; c_in = 0;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Simple addition no carries", test_num);
            a = 4'b0010; b = 4'b0101; c_in = 0;
            #1;

            check_outputs(4'b0000, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Addition with carry-in only", test_num);
            a = 4'b0001; b = 4'b0010; c_in = 1;
            #1;

            check_outputs(4'b0000, 4'b0100);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry generated at bit 0", test_num);
            a = 4'b0001; b = 4'b0001; c_in = 0;

            #1;


            check_outputs(4'b0001, 4'b0010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry generated at bit 2", test_num);
            a = 4'b0100; b = 4'b0110; c_in = 0;


            #1;



            check_outputs(4'b0100, 4'b1010);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Propagate carry from bit 0 to bit 3", test_num);
            a = 4'b1110; b = 4'b0001; c_in = 1;


            #1;



            check_outputs(4'b1111, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Max values with carry-in", test_num);
            a = 4'b1111; b = 4'b1111; c_in = 1;


            #1;



            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed generate and propagate", test_num);
            a = 4'b1011; b = 4'b0101; c_in = 0;






            #1;







            check_outputs(4'b1111, 4'b0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry out of bit 3 only", test_num);
            a = 4'b1000; b = 4'b1000; c_in = 0;


            #1;



            check_outputs(4'b1000, 4'b0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bits", test_num);
            a = 4'b1010; b = 4'b0101; c_in = 1;



            #1;




            check_outputs(4'b1111, 4'b0000);
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
        input [3:0] expected_carry_ahead;
        input [3:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_carry_ahead === (expected_carry_ahead ^ carry_ahead ^ expected_carry_ahead) &&
                expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: carry_ahead=%h, sum=%h",
                         carry_ahead, sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: carry_ahead=%h, sum=%h",
                         expected_carry_ahead, expected_sum);
                $display("  Got:      carry_ahead=%h, sum=%h",
                         carry_ahead, sum);
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
