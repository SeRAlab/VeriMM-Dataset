`timescale 1ns/1ps

module carry_save_adder_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] A;
    reg [2:0] B;
    reg [2:0] C;
    wire [2:0] C_out;
    wire [3:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    carry_save_adder dut (
        .A(A),
        .B(B),
        .C(C),
        .C_out(C_out),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            A = 3'b000; B = 3'b000; C = 3'b000;
            $display("Testcase %0d: All inputs zero", test_num);
            #1;

            check_outputs(3'b000, 4'b0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            A = 3'b111; B = 3'b111; C = 3'b111;
            $display("Testcase %0d: All bits set (7, 7, 7)", test_num);
            #1;

            check_outputs(3'b111, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            A = 3'b001; B = 3'b010; C = 3'b100;
            $display("Testcase %0d: Distributed bits (1, 2, 4)", test_num);
            #1;

            check_outputs(3'b000, 4'b0111);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            A = 3'b111; B = 3'b111; C = 3'b000;
            $display("Testcase %0d: Two inputs high (7, 7, 0)", test_num);
            #1;

            check_outputs(3'b111, 4'b0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            A = 3'b001; B = 3'b001; C = 3'b001;
            $display("Testcase %0d: Bit 0 Carry Generation", test_num);
            #1;

            check_outputs(3'b001, 4'b0001);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            A = 3'b101; B = 3'b010; C = 3'b111;
            $display("Testcase %0d: Alternating Bits (5, 2, 7)", test_num);
            #1;

            check_outputs(3'b111, 4'b0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            A = 3'b011; B = 3'b110; C = 3'b100;
            $display("Testcase %0d: Mixed Values (3, 6, 4)", test_num);
            #1;

            check_outputs(3'b110, 4'b0001);
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
        input [2:0] expected_C_out;
        input [3:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C_out === (expected_C_out ^ C_out ^ expected_C_out) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C_out=%h, S=%h",
                         C_out, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C_out=%h, S=%h",
                         expected_C_out, expected_S);
                $display("  Got:      C_out=%h, S=%h",
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
