`timescale 1ns/1ps

module zzinc48_tb;

    // Testbench signals (combinational circuit)
    reg [47:0] in;
    wire [47:0] out;
    wire overflow;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    zzinc48 dut (
        .in(in),
        .out(out),
        .overflow(overflow)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero input", test_num);
        in = 48'h0000_0000_0000;
        #1;

        check_outputs(48'h0000_0000_0001, 1'b0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small value", test_num);
        in = 48'h0000_0000_000A;
        #1;

        check_outputs(48'h0000_0000_000B, 1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: One below signed max positive", test_num);
        in = 48'h7FFF_FFFF_FFFE;
        #1;

        check_outputs(48'h7FFF_FFFF_FFFF, 1'b0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed overflow boundary (Max Positive)", test_num);
        in = 48'h7FFF_FFFF_FFFF;
        #1;

        check_outputs(48'h8000_0000_0000, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Signed max negative", test_num);
        in = 48'h8000_0000_0000;
        #1;

        check_outputs(48'h8000_0000_0001, 1'b0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative value increment", test_num);
        in = 48'hAAAA_BBBB_CCCC;
        #1;

        check_outputs(48'hAAAA_BBBB_CCCD, 1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Unsigned wrap-around (All bits 1)", test_num);
        in = 48'hFFFF_FFFF_FFFF;
        #1;

        check_outputs(48'h0000_0000_0000, 1'b0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large positive value", test_num);
        in = 48'h1234_5678_9ABC;
        #1;

        check_outputs(48'h1234_5678_9ABD, 1'b0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("zzinc48 Testbench");
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
        input [47:0] expected_out;
        input expected_overflow;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out) &&
                expected_overflow === (expected_overflow ^ overflow ^ expected_overflow)) begin
                $display("PASS");
                $display("  Outputs: out=%h, overflow=%b",
                         out, overflow);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h, overflow=%b",
                         expected_out, expected_overflow);
                $display("  Got:      out=%h, overflow=%b",
                         out, overflow);
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
