`timescale 1ns/1ps

module ripple_carry_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg CIN;
    wire COUT;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    ripple_carry_adder dut (
        .A(A),
        .B(B),
        .CIN(CIN),
        .COUT(COUT),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test %0d: All zeros", test_num);
        A = 4'd0; B = 4'd0; CIN = 1'b0;
        #1;

        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: Maximum values with carry-in", test_num);
        A = 4'd15; B = 4'd15; CIN = 1'b1;

        #1;


        check_outputs(1'b1, 4'd15);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: Simple addition no carries", test_num);
        A = 4'd5; B = 4'd2; CIN = 1'b0;
        #1;

        check_outputs(1'b0, 4'd7);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: Addition resulting in exactly 16", test_num);
        A = 4'd8; B = 4'd8; CIN = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: Carry propagation from CIN to S[0]", test_num);
        A = 4'd0; B = 4'd0; CIN = 1'b1;
        #1;

        check_outputs(1'b0, 4'd1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: Multiple internal carries", test_num);
        A = 4'd7; B = 4'd1; CIN = 1'b0;

        #1;


        check_outputs(1'b0, 4'd8);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: Boundary condition A=15, B=0, CIN=1", test_num);
        A = 4'd15; B = 4'd0; CIN = 1'b1;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: Addition near carry-out threshold", test_num);
        A = 4'd10; B = 4'd5; CIN = 1'b0;
        #1;

        check_outputs(1'b0, 4'd15);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: A=10, B=6, CIN=0 (16 exactly)", test_num);
        A = 4'd10; B = 4'd6; CIN = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: Random pattern check", test_num);
        A = 4'd12; B = 4'd12; CIN = 1'b1;

        #1;


        check_outputs(1'b1, 4'd9);
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
        input expected_COUT;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_COUT === (expected_COUT ^ COUT ^ expected_COUT) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: COUT=%b, S=%h",
                         COUT, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: COUT=%b, S=%h",
                         expected_COUT, expected_S);
                $display("  Got:      COUT=%b, S=%h",
                         COUT, S);
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
