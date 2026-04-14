`timescale 1ns/1ps

module xnor_gate_4bit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] A;
    reg [3:0] B;
    wire [3:0] Y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xnor_gate_4bit dut (
        .A(A),
        .B(B),
        .Y(Y)
    );
    task testcase001;

    begin
        test_num = 1;
        A = 4'b0000;
        B = 4'b0000;
        $display("Test %0d: All Zeros (A=0, B=0)", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        A = 4'b1111;
        B = 4'b1111;
        $display("Test %0d: All Ones (A=F, B=F)", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        A = 4'b1111;
        B = 4'b0000;
        $display("Test %0d: Opposite All (A=F, B=0)", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        A = 4'b1010;
        B = 4'b1010;
        $display("Test %0d: Alternating matching (A=A, B=A)", test_num);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        A = 4'b1100;
        B = 4'b1010;

        $display("Test %0d: Mixed bits (A=C, B=A)", test_num);
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        A = 4'b1101;
        B = 4'b0010;
        $display("Test %0d: Inverse bits (A=D, B=2)", test_num);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        A = 4'b0001;
        B = 4'b1000;
        $display("Test %0d: Walking Bit mismatch (A=1, B=8)", test_num);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xnor_gate_4bit Testbench");
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
        input [3:0] expected_Y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Y === (expected_Y ^ Y ^ expected_Y)) begin
                $display("PASS");
                $display("  Outputs: Y=%h",
                         Y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Y=%h",
                         expected_Y);
                $display("  Got:      Y=%h",
                         Y);
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
