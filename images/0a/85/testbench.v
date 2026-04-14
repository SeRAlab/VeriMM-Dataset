`timescale 1ns/1ps

module multiplier_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero multiplication (0 * 0)", test_num);
            a = 64'h0;
            b = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiply by zero (Max * 0)", test_num);
            a = 64'hFFFFFFFF_FFFFFFFF;
            b = 64'h0;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Identity multiplication (1 * 1)", test_num);
            a = 64'h1;
            b = 64'h1;
            #1;

            check_outputs(128'h1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiply by one (Max * 1)", test_num);
            a = 64'hFFFFFFFF_FFFFFFFF;
            b = 64'h1;
            #1;

            check_outputs(128'h00000000_00000000_FFFFFFFF_FFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small product (Power of 2)", test_num);
            a = 64'h00000000_00000010;
            b = 64'h00000000_00000400;
            #1;

            check_outputs(128'h00000000_00000000_00000000_00004000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Result crossing 64-bit boundary", test_num);
            a = 64'h80000000_00000000;
            b = 64'h2;
            #1;

            check_outputs(128'h00000000_00000001_00000000_00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum possible values (Max * Max)", test_num);
            a = 64'hFFFFFFFF_FFFFFFFF;
            b = 64'hFFFFFFFF_FFFFFFFF;

            #1;


            check_outputs(128'hFFFFFFFF_FFFFFFFE_00000000_00000001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large arbitrary values", test_num);
            a = 64'hFEDCBA98_76543210;
            b = 64'h01234567_89ABCDEF;
            #1;

            check_outputs(128'h121FB32D_C9438090_09E83F0E_F294C000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Square of large power of 2", test_num);
            a = 64'h10000000_00000000;
            b = 64'h10000000_00000000;
            #1;

            check_outputs(128'h01000000_00000000_00000000_00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Alternating bits", test_num);
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;

            #1;


            check_outputs(128'h38E38E38_E38E38E3_8E38E38E_38E38E38);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64bit Testbench");
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
        input [127:0] expected_product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product)) begin
                $display("PASS");
                $display("  Outputs: product=%h",
                         product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h",
                         expected_product);
                $display("  Got:      product=%h",
                         product);
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
