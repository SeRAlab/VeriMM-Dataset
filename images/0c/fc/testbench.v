`timescale 1ns/1ps

module KoggeStoneAdder_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] A;
    reg [4:0] B;
    wire [4:0] S;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    KoggeStoneAdder dut (
        .A(A),
        .B(B),
        .S(S),
        .carry_out(carry_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 5'd0;
            B = 5'd0;
            $display("Testcase %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 5'd15;
            B = 5'd0;
            $display("Testcase %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd15, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 5'd5;
            B = 5'd3;
            $display("Testcase %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd8, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 5'd7;
            B = 5'd1;
            $display("Testcase %03d: A=%d, B=%d (Internal Carry Propagate)", test_num, A, B);
            #1;

            check_outputs(5'd8, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 5'd16;
            B = 5'd15;
            $display("Testcase %03d: A=%d, B=%d (Max Sum No Carry Out)", test_num, A, B);
            #1;

            check_outputs(5'd31, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 5'd16;
            B = 5'd16;
            $display("Testcase %03d: A=%d, B=%d (Carry Out Generation)", test_num, A, B);
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 5'd31;
            B = 5'd1;
            $display("Testcase %03d: A=%d, B=%d (Full Chain Carry Out)", test_num, A, B);
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 5'd31;
            B = 5'd31;
            $display("Testcase %03d: A=%d, B=%d (Max Inputs)", test_num, A, B);
            #1;

            check_outputs(5'd30, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 5'b10101;
            B = 5'b01010;
            $display("Testcase %03d: A=%b, B=%b (Alternating bits)", test_num, A, B);
            #1;

            check_outputs(5'b11111, 1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 5'd27;
            B = 5'd5;
            $display("Testcase %03d: A=%d, B=%d (Exact wrap)", test_num, A, B);
            #1;

            check_outputs(5'd0, 1'b1);
        end
        endtask

    task testcase011;

        begin
            test_num = test_num + 1;
            A = 5'd10;
            B = 5'd10;
            $display("Testcase %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd20, 1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = test_num + 1;
            A = 5'd1;
            B = 5'd1;
            $display("Testcase %03d: A=%d, B=%d", test_num, A, B);
            #1;

            check_outputs(5'd2, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("KoggeStoneAdder Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input expected_carry_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: S=%h, carry_out=%b",
                         S, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, carry_out=%b",
                         expected_S, expected_carry_out);
                $display("  Got:      S=%h, carry_out=%b",
                         S, carry_out);
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
