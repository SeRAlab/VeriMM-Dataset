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
            test_num = 1;
            $display("\nTest Case %0d: Zero Multiplication", test_num);
            a = 64'h0;
            b = 64'hFEDCBA9876543210;
            #1;

            check_outputs(128'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: Multiplication by One", test_num);
            a = 64'h1;
            b = 64'hABCDEFFEDCBA0123;
            #1;

            check_outputs(128'hABCDEFFEDCBA0123);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Maximum Values (All Ones)", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;

            #1;


            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Power of 2 (32-bit boundary)", test_num);
            a = 64'h0000000100000000;
            b = 64'h0000000100000000;
            #1;

            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: 32-bit Max Values", test_num);
            a = 64'h00000000FFFFFFFF;
            b = 64'h00000000FFFFFFFF;
            #1;

            check_outputs(128'h0000000000000000FFFFFFFE00000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest Case %0d: Mixed High/Low parts", test_num);
            a = 64'hFFFFFFFF00000000;
            b = 64'h00000000FFFFFFFF;
            #1;

            check_outputs(128'h00000000FFFFFFFFFFFFFFFE00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest Case %0d: Large Hex Multiplication", test_num);
            a = 64'h1234567812345678;
            b = 64'h8765432187654321;

            #1;


            check_outputs(128'h0000099A66D482563F6A25668CA9647228A8);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest Case %0d: Large Numbers", test_num);
            a = 64'hDEADBEEFCAFEBABE;
            b = 64'h0123456789ABCDEF;

            #1;


            check_outputs(128'h000FD6D8343C78B9467657159DA04D3C52);
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
