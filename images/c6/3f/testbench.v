`timescale 1ns/1ps

module comb_circuit_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] in;
    wire [2:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    comb_circuit dut (
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 0 (Condition: < 4, Expected Out: 1)", test_num);
        in = 4'd0;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 3 (Condition: < 4, Expected Out: 4)", test_num);
        in = 4'd3;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 4 (Condition: >= 4, Expected Out: 3)", test_num);
        in = 4'd4;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 1 (Condition: < 4, Expected Out: 2)", test_num);
        in = 4'd1;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 8 (Condition: >= 4, Expected Out: 7)", test_num);
        in = 4'd8;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 9 (Condition: >= 4, Expected Out: 8 -> 3-bit truncated to 0)", test_num);
        in = 4'd9;

        #1;


        check_outputs(3'd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 15 (Condition: >= 4, Expected Out: 14 -> 3-bit truncated to 6)", test_num);
        in = 4'd15;

        #1;


        check_outputs(3'd6);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Input = 5 (Condition: >= 4, Expected Out: 4)", test_num);
        in = 4'd5;
        #1;

        check_outputs(3'd4);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("comb_circuit Testbench");
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
        input [2:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
