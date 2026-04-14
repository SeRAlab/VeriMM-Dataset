`timescale 1ns/1ps

module sum_4_bits_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] in;
    wire [3:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sum_4_bits dut (
        .in(in),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Zero input", test_num);
            in = 16'h0000;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Simple sum without overflow", test_num);
            in = 16'h1002;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Sum with truncation (overflow)", test_num);
            in = 16'h8008;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum nibbles sum", test_num);
            in = 16'hF00F;
            #1;

            check_outputs(4'hE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Specification example (0xABCD)", test_num);
            in = 16'hABCD;
            #1;

            check_outputs(4'h7);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Verify middle bits are ignored", test_num);
            in = 16'h0FF0;
            #1;

            check_outputs(4'h0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mixed nibbles", test_num);
            in = 16'h5005;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Edge case 1 + F", test_num);
            in = 16'h100F;
            #1;

            check_outputs(4'h0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sum_4_bits Testbench");
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
