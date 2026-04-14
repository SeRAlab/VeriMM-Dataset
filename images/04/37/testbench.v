`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] C;
    wire [3:0] carry;
    wire [3:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .carry(carry),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            A = 4'b0000; B = 4'b0000; C = 4'b0000;
            #1;

            check_outputs(4'b0000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones (Full Carry and Sum)", test_num);
            A = 4'b1111; B = 4'b1111; C = 4'b1111;
            #1;

            check_outputs(4'b1111, 4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit set in each input (different positions)", test_num);
            A = 4'b0001; B = 4'b0010; C = 4'b0100;
            #1;

            check_outputs(4'b0000, 4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit set in each input (same position)", test_num);
            A = 4'b0001; B = 4'b0001; C = 4'b0001;
            #1;

            check_outputs(4'b0001, 4'b0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Two inputs set to same value, one zero", test_num);
            A = 4'b1010; B = 4'b1010; C = 4'b0000;
            #1;

            check_outputs(4'b1010, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bit patterns", test_num);
            A = 4'b1010; B = 4'b0101; C = 4'b1111;




            #1;





            check_outputs(4'b1111, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random combination 1", test_num);
            A = 4'b1100; B = 4'b0110; C = 4'b0011;




            #1;





            check_outputs(4'b0110, 4'b1001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values with different overlaps", test_num);
            A = 4'b0111; B = 4'b0011; C = 4'b0001;




            #1;





            check_outputs(4'b0011, 4'b0101);
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
