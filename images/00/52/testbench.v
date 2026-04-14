`timescale 1ns/1ps

module carry_skip_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg Cin;
    wire Cout;
    wire [3:0] Sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_skip_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .Sum(Sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero addition", test_num);
            A = 4'b0000; B = 4'b0000; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Simple addition without carry", test_num);
            A = 4'b0010; B = 4'b0001; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Addition with carry-in", test_num);
            A = 4'b0101; B = 4'b0010; Cin = 1'b1;
            #1;

            check_outputs(1'b0, 4'b1000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry generation at MSB", test_num);
            A = 4'b1000; B = 4'b1000; Cin = 1'b0;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry skip condition (All Propagate = 1, Cin = 1)", test_num);

            A = 4'b1010; B = 4'b0101; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry skip condition (All Propagate = 1, Cin = 0)", test_num);
            A = 4'b1010; B = 4'b0101; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Maximum values", test_num);
            A = 4'b1111; B = 4'b1111; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal ripple carry (No skip)", test_num);

            A = 4'b0001; B = 4'b1111; Cin = 1'b0;
            #1;

            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Partial propagation", test_num);
            A = 4'b1100; B = 4'b0011; Cin = 1'b1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Large sum, no carry out", test_num);
            A = 4'b0111; B = 4'b0111; Cin = 1'b1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_skip_adder Testbench");
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
        input [3:0] expected_Sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Cout === (expected_Cout ^ Cout ^ expected_Cout) &&
                expected_Sum === (expected_Sum ^ Sum ^ expected_Sum)) begin
                $display("PASS");
                $display("  Outputs: Cout=%b, Sum=%h",
                         Cout, Sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Cout=%b, Sum=%h",
                         expected_Cout, expected_Sum);
                $display("  Got:      Cout=%b, Sum=%h",
                         Cout, Sum);
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
