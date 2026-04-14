`timescale 1ns/1ps

module csa_4bit_tb;

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
    csa_4bit dut (
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
            A = 4'h0; B = 4'h0; C = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Ones", test_num);
            A = 4'hF; B = 4'hF; C = 4'hF;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating Bits (A/5/0)", test_num);
            A = 4'hA; B = 4'h5; C = 4'h0;

            #1;


            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Single bit overlap", test_num);
            A = 4'h1; B = 4'h1; C = 4'h0;

            #1;


            check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Complex bits (7, 3, 1)", test_num);
            A = 4'h7; B = 4'h3; C = 4'h1;






            #1;







            check_outputs(4'h3, 4'h5);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum bit shifts", test_num);
            A = 4'hE; B = 4'h7; C = 4'hB;





            #1;






            check_outputs(4'hF, 4'h2);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Power of 2 bits", test_num);
            A = 4'h1; B = 4'h2; C = 4'h4;


            #1;



            check_outputs(4'h0, 4'h7);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("csa_4bit Testbench");
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
