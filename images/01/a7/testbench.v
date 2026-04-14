`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 4'd0;
            B = 4'd0;
            $display("Test %0d: A=%d, B=%d (Zero Case)", test_num, A, B);
            #1;

            check_outputs(5'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd0;
            $display("Test %0d: A=%d, B=%d (Identity)", test_num, A, B);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd1;
            $display("Test %0d: A=%d, B=%d (Ripple Carry Propagation)", test_num, A, B);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 4'd15;
            B = 4'd15;
            $display("Test %0d: A=%d, B=%d (Maximum Sum)", test_num, A, B);
            #1;

            check_outputs(5'd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 4'd10;
            B = 4'd5;
            $display("Test %0d: A=%d, B=%d (Alternating Bits)", test_num, A, B);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 4'd8;
            B = 4'd8;
            $display("Test %0d: A=%d, B=%d (MSB Carry)", test_num, A, B);
            #1;

            check_outputs(5'd16);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 4'd7;
            B = 4'd8;
            $display("Test %0d: A=%d, B=%d (No Carry Out)", test_num, A, B);
            #1;

            check_outputs(5'd15);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            A = 4'd12;
            B = 4'd13;
            $display("Test %0d: A=%d, B=%d (Random Addition)", test_num, A, B);
            #1;

            check_outputs(5'd25);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            A = 4'd1;
            B = 4'd2;
            $display("Test %0d: A=%d, B=%d (Small Sum)", test_num, A, B);
            #1;

            check_outputs(5'd3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            A = 4'b1011;
            B = 4'b0110;
            $display("Test %0d: A=%b, B=%b (Bitwise Check)", test_num, A, B);
            #1;

            check_outputs(5'd17);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("ripple_carry_adder Testbench");
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
        input [4:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Sum=%h",
                         Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Sum=%h",
                         expected_Sum);
                $display("  Got:      Sum=%h",
                         Sum);
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
