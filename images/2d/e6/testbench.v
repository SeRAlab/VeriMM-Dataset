`timescale 1ns/1ps

module multiplier32x32_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier32x32 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplying by zero (0 * 0)", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0000;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplying by zero (val * 0)", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0000_0000;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplying by one (Identity)", test_num);
            a = 32'hABCD_EF12;
            b = 32'h0000_0001;
            #1;

            check_outputs(64'h0000_0000_ABCD_EF12);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small integers (123 * 456)", test_num);
            a = 32'd123;
            b = 32'd456;
            #1;

            check_outputs(64'd56088);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of two (2^16 * 2^15)", test_num);
            a = 32'h0001_0000;
            b = 32'h0000_8000;
            #1;

            check_outputs(64'h0000_0000_8000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum unsigned values (2^32-1)^2", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;

            #1;


            check_outputs(64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit patterns", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            #1;

            check_outputs(64'h38E3_8E38_71C7_1C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large arbitrary values", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            #1;

            check_outputs(64'h09A1_290E_D29E_E678);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large Primes", test_num);
            a = 32'd104729;
            b = 32'd15485863;
            #1;

            check_outputs(64'd1621818816127);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication resulting in upper 32-bit data", test_num);
            a = 32'hF000_0000;
            b = 32'hF000_0000;
            #1;

            check_outputs(64'hE100_0000_0000_0000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier32x32 Testbench");
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
        input [63:0] expected_product;
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
