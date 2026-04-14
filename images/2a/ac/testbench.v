`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg [3:0] Cin;
    wire [3:0] C;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .C(C),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Zeros", test_num);
            A = 4'h0;
            B = 4'h0;
            Cin = 4'h0;
            #1;

            check_outputs(4'h0, 4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: All Ones", test_num);
            A = 4'hF;
            B = 4'hF;
            Cin = 4'hF;
            #1;

            check_outputs(4'hF, 4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Single bit carry (Bit 0)", test_num);
            A = 4'h1;
            B = 4'h1;
            Cin = 4'h0;
            #1;

            check_outputs(4'h1, 4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed inputs (Scenario A)", test_num);





            A = 4'h7;
            B = 4'h3;
            Cin = 4'h1;
            #1;

            check_outputs(4'h3, 4'h5);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Mixed inputs (Scenario B)", test_num);





            A = 4'hE;
            B = 4'h8;
            Cin = 4'h2;
            #1;

            check_outputs(4'hA, 4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating Bits", test_num);



            A = 4'hA;
            B = 4'h5;
            Cin = 4'h0;
            #1;

            check_outputs(4'h0, 4'hF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Carry across all bits", test_num);



            A = 4'hF;
            B = 4'h0;
            Cin = 4'hF;
            #1;

            check_outputs(4'hF, 4'h0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Complementary Inputs", test_num);



            A = 4'hC;
            B = 4'h3;
            Cin = 4'hA;
            #1;

            check_outputs(4'hA, 4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("carry_save_adder Testbench");
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
        input [3:0] expected_C;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C === (expected_C ^ C ^ expected_C) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C=%h, S=%h",
                         C, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C=%h, S=%h",
                         expected_C, expected_S);
                $display("  Got:      C=%h, S=%h",
                         C, S);
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
