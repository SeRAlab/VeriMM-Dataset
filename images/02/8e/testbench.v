`timescale 1ns/1ps

module eight_bit_adder_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] A;
    reg [7:0] B;
    wire C_out;
    wire [7:0] S;
    wire V;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    eight_bit_adder dut (
        .A(A),
        .B(B),
        .C_out(C_out),
        .S(S),
        .V(V)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple Positive Addition (No Overflow)", test_num);
            A = 8'd10;
            B = 8'd20;

            #1;


            check_outputs(1'b0, 8'h1E, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Unsigned Carry-Out (Max Unsigned)", test_num);
            A = 8'hFF;
            B = 8'h01;

            #1;


            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Overflow (Positive + Positive)", test_num);
            A = 8'h7F;
            B = 8'h01;

            #1;


            check_outputs(1'b0, 8'h80, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Signed Overflow (Negative + Negative)", test_num);
            A = 8'h80;
            B = 8'hFF;

            #1;


            check_outputs(1'b1, 8'h7F, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Addition", test_num);
            A = 8'h00;
            B = 8'h00;
            #1;

            check_outputs(1'b0, 8'h00, 1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Negative Addition (No Overflow)", test_num);
            A = 8'hF6;
            B = 8'hEC;

            #1;


            check_outputs(1'b1, 8'hE2, 1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed Sign Resulting in Zero", test_num);
            A = 8'd50;
            B = -8'd50;

            #1;


            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Negative Addition (Overflow)", test_num);
            A = 8'h80;
            B = 8'h80;

            #1;


            check_outputs(1'b1, 8'h00, 1'b1);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum Positive Addition (Overflow)", test_num);
            A = 8'h7F;
            B = 8'h7F;

            #1;


            check_outputs(1'b0, 8'hFE, 1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Negative + Large Positive (No Overflow)", test_num);
            A = 8'h81;
            B = 8'h7F;

            #1;


            check_outputs(1'b1, 8'h00, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("eight_bit_adder Testbench");
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
        input [7:0] expected_S;
        input expected_V;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S) &&
                expected_V === (expected_V ^ V ^ expected_V)) begin
                $display("PASS");
                $display("  Outputs: C_out=%b, S=%h, V=%b",
                         C_out, S, V);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%b, S=%h, V=%b",
                         expected_C_out, expected_S, expected_V);
                $display("  Got:      C_out=%b, S=%h, V=%b",
                         C_out, S, V);
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
