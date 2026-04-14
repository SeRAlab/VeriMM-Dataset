`timescale 1ns/1ps

module compare_4bit_inputs_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] C;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    compare_4bit_inputs dut (
        .A(A),
        .B(B),
        .C(C)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd2;
            B = 4'd5;
            $display("Test %0d: A < B case (A=2, B=5)", test_num);
            #1;

            check_outputs(4'd2);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd3;
            $display("Test %0d: A > B case (A=10, B=3)", test_num);
            #1;

            check_outputs(4'd3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd7;
            $display("Test %0d: A == B case (A=7, B=7)", test_num);
            #1;

            check_outputs(4'd7);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd15;
            $display("Test %0d: Minimum A vs Maximum B", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd0;
            $display("Test %0d: Maximum A vs Minimum B", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd1;
            B = 4'd0;
            $display("Test %0d: Near zero edge case (A=1, B=0)", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd14;
            B = 4'd15;
            $display("Test %0d: Near max edge case (A=14, B=15)", test_num);
            #1;

            check_outputs(4'd14);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            $display("Test %0d: Maximum values equal", test_num);
            #1;

            check_outputs(4'd15);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            $display("Test %0d: Minimum values equal", test_num);
            #1;

            check_outputs(4'd0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd12;
            $display("Test %0d: Random logic check (A=8, B=12)", test_num);
            #1;

            check_outputs(4'd8);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("compare_4bit_inputs Testbench");
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
        input [3:0] expected_C;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C)) begin
                $display("PASS");
                $display("  Outputs: C=%h",
                         C);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h",
                         expected_C);
                $display("  Got:      C=%h",
                         C);
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
