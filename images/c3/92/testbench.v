`timescale 1ns/1ps

module logic_circuit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    logic_circuit dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test Case 001: All zeros");
            in = 8'b0000_0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test Case 002: All ones");
            in = 8'b1111_1111;
            #1;

            check_outputs(4'hF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test Case 003: First four mixed (OR=1, AND=0), Last four zero");
            in = 8'b0000_0001;
            #1;

            check_outputs(4'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test Case 004: First four all ones (OR=1, AND=1), Last four zero");
            in = 8'b0000_1111;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test Case 005: First four zero, Last four mixed (OR=1, AND=0)");
            in = 8'b0001_0000;
            #1;

            check_outputs(4'h4);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test Case 006: First four zero, Last four all ones (OR=1, AND=1)");
            in = 8'b1111_0000;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test Case 007: First four all ones, Last four mixed");
            in = 8'b0111_1111;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test Case 008: First four mixed, Last four all ones");
            in = 8'b1111_0111;
            #1;

            check_outputs(4'hD);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test Case 009: Alternating bits (Mixed groups)");
            in = 8'b0101_0101;
            #1;

            check_outputs(4'h5);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("logic_circuit Testbench");
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
        input [3:0] expected_out;
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
