`timescale 1ns/1ps

module vector_adder_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    reg EN;
    wire C_out;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    vector_adder dut (
        .A(A),
        .B(B),
        .EN(EN),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Addition without Carry", test_num);
            A = 4'd3;
            B = 4'd4;
            EN = 1'b1;
            #1;

            check_outputs(1'b0, 4'd7);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Carry-Out", test_num);
            A = 4'd10;
            B = 4'd10;
            EN = 1'b1;

            #1;


            check_outputs(1'b1, 4'd4);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max Values (15 + 15)", test_num);
            A = 4'd15;
            B = 4'd15;
            EN = 1'b1;

            #1;


            check_outputs(1'b1, 4'hE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Addition with Zero", test_num);
            A = 4'd12;
            B = 4'd0;
            EN = 1'b1;
            #1;

            check_outputs(1'b0, 4'd12);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Enable signal LOW (Invalid Logic)", test_num);
            A = 4'd5;
            B = 4'd5;
            EN = 1'b0;


            #1;



            check_outputs(1'b0, 4'd0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Boundary Case (15 + 1)", test_num);
            A = 4'd15;
            B = 4'd1;
            EN = 1'b1;

            #1;


            check_outputs(1'b1, 4'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern Test (5 + 10)", test_num);
            A = 4'b0101;
            B = 4'b1010;
            EN = 1'b1;
            #1;

            check_outputs(1'b0, 4'b1111);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Toggle Enable", test_num);
            A = 4'd7;
            B = 4'd2;
            EN = 1'b1;
            #5;
            EN = 1'b0;
            #5;
            EN = 1'b1;
            #1;

            check_outputs(1'b0, 4'd9);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("vector_adder Testbench");
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
