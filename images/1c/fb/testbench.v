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
        test_num = test_num + 1;
        A = 4'b0000;
        B = 4'b0000;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b00000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        A = 4'b1111;
        B = 4'b0001;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        A = 4'b1111;
        B = 4'b1111;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b11110);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        A = 4'b0101;
        B = 4'b1010;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        A = 4'b1000;
        B = 4'b1000;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b10000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        A = 4'b0111;
        B = 4'b0001;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b01000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        A = 4'b0011;
        B = 4'b0100;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b00111);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        A = 4'b1001;
        B = 4'b0110;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b01111);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        A = 4'b1100;
        B = 4'b1101;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b11001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        A = 4'b0001;
        B = 4'b0010;
        $display("\nTest Case %0d: A=%d, B=%d", test_num, A, B);
        #1;

        check_outputs(5'b00011);
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
