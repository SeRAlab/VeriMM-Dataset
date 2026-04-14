`timescale 1ns/1ps

module four_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'h0; B = 4'h0; Cin = 1'b0;
        $display("Test Case %0d: All Zeros (A=0, B=0, Cin=0)", test_num);
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'h5; B = 4'h3; Cin = 1'b0;
        $display("Test Case %0d: Simple addition without carry-out (5+3=8)", test_num);
        #1;

        check_outputs(1'b0, 4'h8);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'hA; B = 4'h5; Cin = 1'b0;
        $display("Test Case %0d: Alternating bits (A+5=F)", test_num);
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'hA; B = 4'h5; Cin = 1'b1;
        $display("Test Case %0d: Alternating bits with carry-in (A+5+1=10)", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'h8; B = 4'h8; Cin = 1'b0;
        $display("Test Case %0d: Carry-out from MSB (8+8=10)", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'hF; B = 4'hF; Cin = 1'b1;
        $display("Test Case %0d: Maximum possible sum (F+F+1=1F)", test_num);
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'h7; B = 4'h1; Cin = 1'b0;
        $display("Test Case %0d: Internal carry propagation (7+1=8)", test_num);
        #1;

        check_outputs(1'b0, 4'h8);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'h1; B = 4'hE; Cin = 1'b0;
        $display("Test Case %0d: Simple addition (1+E=F)", test_num);
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'h3; B = 4'hC; Cin = 1'b1;
        $display("Test Case %0d: Mid-range addition with carry (3+C+1=10)", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'h9; B = 4'h6; Cin = 1'b0;
        $display("Test Case %0d: Sum is 15 (9+6=F)", test_num);
        #1;

        check_outputs(1'b0, 4'hF);
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
        input expected_Cout;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, S=%h",
                         Cout, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, S=%h",
                         expected_Cout, expected_S);
                $display("  Got:      Cout=%b, S=%h",
                         Cout, S);
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
