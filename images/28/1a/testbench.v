`timescale 1ns/1ps

module CarrySkipAdder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    reg Skip;
    wire Cout;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    CarrySkipAdder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Skip(Skip),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Basic addition (2+3), Cin=0, Skip=0", test_num);
        A = 4'd2;
        B = 4'd3;
        Cin = 1'b0;
        Skip = 1'b0;
        #1;

        check_outputs(1'b0, 4'd5);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Cin (5+5+1), Skip=0", test_num);
        A = 4'd5;
        B = 4'd5;
        Cin = 1'b1;
        Skip = 1'b0;
        #1;

        check_outputs(1'b0, 4'd11);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Addition with Cout (8+8), Skip=0", test_num);
        A = 4'd8;
        B = 4'd8;
        Cin = 1'b0;
        Skip = 1'b0;
        #1;

        check_outputs(1'b1, 4'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Skip logic - Skip=1, Cin=0 (Cout should be 0 despite A+B)", test_num);
        A = 4'd8;
        B = 4'd8;
        Cin = 1'b0;
        Skip = 1'b1;

        #1;


        check_outputs(1'b0, 4'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Skip logic - Skip=1, Cin=1 (Cout should be 1 despite A+B)", test_num);
        A = 4'd1;
        B = 4'd1;
        Cin = 1'b1;
        Skip = 1'b1;

        #1;


        check_outputs(1'b1, 4'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max values (F+F+1), Skip=0", test_num);
        A = 4'hF;
        B = 4'hF;
        Cin = 1'b1;
        Skip = 1'b0;
        #1;

        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Max values with Skip=1 (F+F+1)", test_num);
        A = 4'hF;
        B = 4'hF;
        Cin = 1'b1;
        Skip = 1'b1;

        #1;


        check_outputs(1'b1, 4'hF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zeros, Skip=0", test_num);
        A = 4'h0;
        B = 4'h0;
        Cin = 1'b0;
        Skip = 1'b0;
        #1;

        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Overflow bits with Skip active", test_num);
        A = 4'hE;
        B = 4'h2;
        Cin = 1'b0;
        Skip = 1'b1;

        #1;


        check_outputs(1'b0, 4'h0);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Toggle bits (A=0xA, B=0x5, Cin=0)", test_num);
        A = 4'hA;
        B = 4'h5;
        Cin = 1'b0;
        Skip = 1'b0;

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
        $display("CarrySkipAdder Testbench");
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
