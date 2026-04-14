`timescale 1ns/1ps

module CLA_4bit_tb;

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
    CLA_4bit dut (
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
        #10;
        $display("Test Case %0d: 0 + 0 + 0", test_num);
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'hA; B = 4'h5; Cin = 1'b0;
        #10;
        $display("Test Case %0d: 1010 + 0101 + 0 (No Carry)", test_num);
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'h0; B = 4'h0; Cin = 1'b1;
        #10;
        $display("Test Case %0d: 0 + 0 + 1 (Cin check)", test_num);
        #1;

        check_outputs(1'b0, 4'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'hF; B = 4'h1; Cin = 1'b0;
        #10;
        $display("Test Case %0d: 1111 + 0001 (Boundary Carry Out)", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'hF; B = 4'hF; Cin = 1'b1;
        #10;
        $display("Test Case %0d: 1111 + 1111 + 1 (Max values)", test_num);
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'h7; B = 4'h8; Cin = 1'b0;
        #10;
        $display("Test Case %0d: 0111 + 1000 (No Carry Out)", test_num);
        #1;

        check_outputs(1'b0, 4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'h3; B = 4'hC; Cin = 1'b1;
        #10;
        $display("Test Case %0d: 0011 + 1100 + 1 (Carry Out check)", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        A = 4'h5; B = 4'h5; Cin = 1'b1;
        #10;
        $display("Test Case %0d: 0101 + 0101 + 1", test_num);
        #1;

        check_outputs(1'b0, 4'hB);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        A = 4'h8; B = 4'h8; Cin = 1'b0;
        #10;
        $display("Test Case %0d: 1000 + 1000 (MSB Carry)", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        A = 4'h9; B = 4'h6; Cin = 1'b1;
        #10;
        $display("Test Case %0d: 1001 + 0110 + 1", test_num);
        #1;

        check_outputs(1'b1, 4'h0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("CLA_4bit Testbench");
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
