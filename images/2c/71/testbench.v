`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [4:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000;
        B = 4'b0000;
        $display("Test %0d: Zero Addition - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'd15;
        B = 4'd0;
        $display("Test %0d: Max A, Zero B - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'd0;
        B = 4'd15;
        $display("Test %0d: Zero A, Max B - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'd1;
        B = 4'd1;
        $display("Test %0d: Simple Addition - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'd15;
        B = 4'd1;
        $display("Test %0d: Carry Out Trigger (LSB to MSB) - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'd15;
        B = 4'd15;
        $display("Test %0d: Maximum Sum - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd30);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b1010;
        B = 4'b0101;
        $display("Test %0d: Alternating Bits - A=%b, B=%b", test_num, A, B);
        #1;

        check_outputs(5'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'd8;
        B = 4'd8;
        $display("Test %0d: MSB Addition - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd16);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'd7;
        B = 4'd4;
        $display("Test %0d: Mid-range Addition - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd11);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'b1100;
        B = 4'b0100;
        $display("Test %0d: Carry into MSB - A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'd16);
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
        input [4:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: S=%h",
                         S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h",
                         expected_S);
                $display("  Got:      S=%h",
                         S);
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
