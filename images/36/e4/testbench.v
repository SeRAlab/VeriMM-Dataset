`timescale 1ns/1ps

module multiplier_16x16_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_16x16 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication", test_num);
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplicative Identity (a * 1)", test_num);
            a = 16'hABCD;
            b = 16'h0001;
            #1;

            check_outputs(32'h0000ABCD);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplicative Identity (1 * b)", test_num);
            a = 16'h0001;
            b = 16'h1234;
            #1;

            check_outputs(32'h00001234);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values (FFFF * FFFF)", test_num);
            a = 16'hFFFF;
            b = 16'hFFFF;

            #1;


            check_outputs(32'hFFFE0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small product", test_num);
            a = 16'h000A;
            b = 16'h0005;
            #1;

            check_outputs(32'h00000032);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Powers of 2 (Shift operation)", test_num);
            a = 16'h0100;
            b = 16'h0100;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern test (AAAA * 5555)", test_num);
            a = 16'hAAAA;
            b = 16'h5555;
            #1;

            check_outputs(32'h38E38E3E);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mixed values", test_num);
            a = 16'h1234;
            b = 16'h5678;
            #1;

            check_outputs(32'h06260060);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow boundary test", test_num);
            a = 16'h8000;
            b = 16'h0002;
            #1;

            check_outputs(32'h00010000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High bit test", test_num);
            a = 16'h8000;
            b = 16'h8000;
            #1;

            check_outputs(32'h40000000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_16x16 Testbench");
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
        input [31:0] expected_product;
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
