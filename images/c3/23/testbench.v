`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg C_in;
    wire C_out;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .C_in(C_in),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("\nTest Case %0d: All zeros", test_num);
        A = 4'b0000;
        B = 4'b0000;
        C_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("\nTest Case %0d: Carry-in only", test_num);
        A = 4'b0000;
        B = 4'b0000;
        C_in = 1'b1;
        #1;

        check_outputs(1'b0, 4'b0001);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("\nTest Case %0d: Simple addition (5 + 3)", test_num);
        A = 4'd5;
        B = 4'd3;
        C_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("\nTest Case %0d: Simple addition with Carry-in (5 + 3 + 1)", test_num);
        A = 4'd5;
        B = 4'd3;
        C_in = 1'b1;
        #1;

        check_outputs(1'b0, 4'd9);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("\nTest Case %0d: Sum is 16 (15 + 1)", test_num);
        A = 4'd15;
        B = 4'd1;
        C_in = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("\nTest Case %0d: Sum is 16 via Carry-in (15 + 0 + 1)", test_num);
        A = 4'd15;
        B = 4'd0;
        C_in = 1'b1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("\nTest Case %0d: Maximum values (15 + 15 + 1)", test_num);
        A = 4'd15;
        B = 4'd15;
        C_in = 1'b1;
        #1;

        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("\nTest Case %0d: Alternating bits (1010 + 0101)", test_num);
        A = 4'b1010;
        B = 4'b0101;
        C_in = 1'b0;
        #1;

        check_outputs(1'b0, 4'b1111);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("\nTest Case %0d: Ripple carry propagation", test_num);
        A = 4'b0111;
        B = 4'b0000;
        C_in = 1'b1;
        #1;

        check_outputs(1'b0, 4'b1000);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("\nTest Case %0d: Mid-range addition with overflow (10 + 10)", test_num);
        A = 4'd10;
        B = 4'd10;
        C_in = 1'b0;
        #1;

        check_outputs(1'b1, 4'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_adder Testbench");
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
        input expected_C_out;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, S=%h",
                         C_out, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, S=%h",
                         expected_C_out, expected_S);
                $display("  Got:      C_out=%b, S=%h",
                         C_out, S);
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
