`timescale 1ns/1ps

module sparc_exu_eclcomp7_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] in1;
    reg [6:0] in2;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sparc_exu_eclcomp7 dut (
        .in1(in1),
        .in2(in2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros (Equal)", test_num);
            in1 = 7'b000_0000;
            in2 = 7'b000_0000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones (Equal)", test_num);
            in1 = 7'b111_1111;
            in2 = 7'b111_1111;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Arbitrary Pattern (Equal)", test_num);
            in1 = 7'b101_0101;
            in2 = 7'b101_0101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Difference at bit 0 (Not Equal)", test_num);
            in1 = 7'b000_0001;
            in2 = 7'b000_0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Difference at bit 6 (Not Equal)", test_num);
            in1 = 7'b100_0000;
            in2 = 7'b000_0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Difference at internal bit pairs (Bit 1-2) (Not Equal)", test_num);
            in1 = 7'b000_0010;
            in2 = 7'b000_0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Difference at internal bit pairs (Bit 3-4) (Not Equal)", test_num);
            in1 = 7'b001_1000;
            in2 = 7'b000_1000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Complementary values (Not Equal)", test_num);
            in1 = 7'b101_0101;
            in2 = 7'b010_1010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Single bit diff at bit 5 (Not Equal)", test_num);
            in1 = 7'b010_0000;
            in2 = 7'b000_0000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max vs Max-1 (Not Equal)", test_num);
            in1 = 7'b111_1111;
            in2 = 7'b111_1110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("sparc_exu_eclcomp7 Testbench");
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
        input expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%b",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%b",
                         expected_out);
                $display("  Got:      out=%b",
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
