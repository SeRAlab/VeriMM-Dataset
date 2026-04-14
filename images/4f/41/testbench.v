`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] forward1;
    reg [31:0] forward2;
    reg iszero;
    reg use1;
    reg use2;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .forward1(forward1),
        .forward2(forward2),
        .iszero(iszero),
        .use1(use1),
        .use2(use2),
        .out(out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: iszero priority", test_num);
            a        = 32'hDEADBEEF;
            forward1 = 32'h12345678;
            forward2 = 32'h87654321;
            use1     = 1;
            use2     = 1;
            iszero   = 1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: use1 forwarding selection", test_num);
            a        = 32'hAAAA_AAAA;
            forward1 = 32'hBBBB_BBBB;
            forward2 = 32'hCCCC_CCCC;
            use1     = 1;
            use2     = 0;
            iszero   = 0;
            #1;

            check_outputs(32'hBBBB_BBBB);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: use2 forwarding selection", test_num);
            a        = 32'hAAAA_AAAA;
            forward1 = 32'hBBBB_BBBB;
            forward2 = 32'hCCCC_CCCC;
            use1     = 0;
            use2     = 1;
            iszero   = 0;
            #1;

            check_outputs(32'hCCCC_CCCC);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Select main input 'a'", test_num);
            a        = 32'h1122_3344;
            forward1 = 32'h5566_7788;
            forward2 = 32'h99AA_BBCC;
            use1     = 0;
            use2     = 0;
            iszero   = 0;
            #1;

            check_outputs(32'h1122_3344);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Priority check (use1 vs use2)", test_num);
            a        = 32'hFFFF_FFFF;
            forward1 = 32'h1111_1111;
            forward2 = 32'h2222_2222;
            use1     = 1;
            use2     = 1;
            iszero   = 0;

            #1;


            check_outputs(32'h1111_1111);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: iszero with no forwarding", test_num);
            a        = 32'h5A5A_A5A5;
            forward1 = 32'h0;
            forward2 = 32'h0;
            use1     = 0;
            use2     = 0;
            iszero   = 1;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        
        
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
        input [31:0] expected_out;
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
