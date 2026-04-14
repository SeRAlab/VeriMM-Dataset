`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire [31:0] S;
    wire carry_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .S(S),
        .carry_out(carry_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            A = 32'h0000_0000;
            B = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Simple addition (no carry)", test_num);
            A = 32'h0000_1234;
            B = 32'h0000_4321;
            #1;

            check_outputs(32'h0000_5555, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max 32-bit result (no carry)", test_num);
            A = 32'hFFFF_0000;
            B = 32'h0000_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry out (0xFFFFFFFF + 1)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'h0000_0001;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Two large values with carry", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFE, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: MSB Carry test", test_num);
            A = 32'h8000_0000;
            B = 32'h8000_0000;
            #1;

            check_outputs(32'h0000_0000, 1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern addition", test_num);
            A = 32'hAAAA_AAAA;
            B = 32'h5555_5555;
            #1;

            check_outputs(32'hFFFF_FFFF, 1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random values check", test_num);
            A = 32'h1234_5678;
            B = 32'h8765_4321;
            #1;

            check_outputs(32'h9999_9999, 1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input [31:0] expected_S;
        input expected_carry_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_S === (expected_S ^ S ^ expected_S) &&
                expected_carry_out === (expected_carry_out ^ carry_out ^ expected_carry_out)) begin
                $display("PASS");
                $display("  Outputs: S=%h, carry_out=%b",
                         S, carry_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: S=%h, carry_out=%b",
                         expected_S, expected_carry_out);
                $display("  Got:      S=%h, carry_out=%b",
                         S, carry_out);
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
