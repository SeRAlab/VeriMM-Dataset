`timescale 1ns/1ps

module and_gate_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and_gate_4bit dut (
        .A(A),
        .B(B),
        .Result(Result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'b0000;
            B = 4'b0000;
            $display("Test Case %0d: A=%b, B=%b (All Zeros)", test_num, A, B);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b1111;
            $display("Test Case %0d: A=%b, B=%b (All Ones)", test_num, A, B);
            #1;

            check_outputs(4'b1111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'b1010;
            B = 4'b0101;
            $display("Test Case %0d: A=%b, B=%b (Alternating bits)", test_num, A, B);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'b1100;
            B = 4'b1010;
            $display("Test Case %0d: A=%b, B=%b (Partial overlap)", test_num, A, B);
            #1;

            check_outputs(4'b1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'b0111;
            B = 4'b0011;
            $display("Test Case %0d: A=%b, B=%b (Masking)", test_num, A, B);
            #1;

            check_outputs(4'b0011);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'b1111;
            B = 4'b1001;
            $display("Test Case %0d: A=%b, B=%b (One input all ones)", test_num, A, B);
            #1;

            check_outputs(4'b1001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'b0000;
            B = 4'b1011;
            $display("Test Case %0d: A=%b, B=%b (One input all zeros)", test_num, A, B);
            #1;

            check_outputs(4'b0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and_gate_4bit Testbench");
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
        input [3:0] expected_Result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Result === (expected_Result ^ Result ^ expected_Result)) begin
                $display("PASS");
                $display("  Outputs: Result=%h",
                         Result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Result=%h",
                         expected_Result);
                $display("  Got:      Result=%h",
                         Result);
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
