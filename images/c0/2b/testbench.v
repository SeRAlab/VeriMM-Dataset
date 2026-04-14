`timescale 1ns/1ps

module sparc_tlu_zcmp64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] in;
    wire zero;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    sparc_tlu_zcmp64 dut (
        .in(in),
        .zero(zero)
    );
    task testcase001;

        begin
            test_num = 1;
            in = 64'h0000_0000_0000_0000;
            $display("Test %0d: Input is all zeros", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            in = 64'h0000_0000_0000_0001;
            $display("Test %0d: Input has LSB set (non-zero)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            in = 64'h8000_0000_0000_0000;
            $display("Test %0d: Input has MSB set (non-zero)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            in = 64'hFFFF_FFFF_FFFF_FFFF;
            $display("Test %0d: Input is all ones (non-zero)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            in = 64'h0000_0000_ABCD_0000;
            $display("Test %0d: Input has middle bits set (non-zero)", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            in = 64'h0000_0000_FFFF_FFFF;
            $display("Test %0d: High word zero, Low word non-zero", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            in = 64'hFFFF_FFFF_0000_0000;
            $display("Test %0d: High word non-zero, Low word zero", test_num);
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
        $display("sparc_tlu_zcmp64 Testbench");
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
        input expected_zero;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zero === (expected_zero ^ zero ^ expected_zero)) begin
                $display("PASS");
                $display("  Outputs: zero=%b",
                         zero);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero=%b",
                         expected_zero);
                $display("  Got:      zero=%b",
                         zero);
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
