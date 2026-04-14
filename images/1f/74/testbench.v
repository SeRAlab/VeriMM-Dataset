`timescale 1ns/1ps

module carry_skip_adder_tb;

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
    carry_skip_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Cout(Cout),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All Zeros", test_num);
            A = 4'b0000; B = 4'b0000; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Basic Addition No Carry", test_num);
            A = 4'b0010; B = 4'b0001; Cin = 1'b0;
            #1;

            check_outputs(1'b0, 4'b0011);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-In only", test_num);
            A = 4'b0000; B = 4'b0000; Cin = 1'b1;
            #1;

            check_outputs(1'b0, 4'b0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Max values with Carry", test_num);
            A = 4'b1111; B = 4'b1111; Cin = 1'b1;
            #1;

            check_outputs(1'b1, 4'b1111);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-Skip Condition (All Propagates True, Cin=0)", test_num);

            A = 4'b1010; B = 4'b0101; Cin = 1'b0;

            #1;


            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Carry-Skip Condition (All Propagates True, Cin=1)", test_num);

            A = 4'b1010; B = 4'b0101; Cin = 1'b1;

            #1;


            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Internal Carry Ripple to Cout", test_num);
            A = 4'b1111; B = 4'b0001; Cin = 1'b0;

            #1;


            check_outputs(1'b1, 4'b0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Mixed bits", test_num);
            A = 4'b1100; B = 4'b0110; Cin = 1'b1;

            #1;


            check_outputs(1'b1, 4'b0011);
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
