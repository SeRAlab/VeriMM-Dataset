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
        $display("Test Case %0d: Zero Multiplication (0 * 0)", test_num);
        a = 64'd0;
        b = 64'd0;
        #1;

        check_outputs(128'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity Multiplication (X * 1)", test_num);
        a = 64'hFEDC_BA98_7654_3210;
        b = 64'd1;
        #1;

        check_outputs({64'h0, 64'hFEDC_BA98_7654_3210});
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Values (123 * 456)", test_num);
        a = 64'd123;
        b = 64'd456;
        #1;

        check_outputs(128'd56088);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Power of 2 (Shift check: 2^32 * 2^32)", test_num);
        a = 64'h0000_0001_0000_0000;
        b = 64'h0000_0001_0000_0000;
        #1;

        check_outputs(128'h0000_0000_0000_0000_0000_0001_0000_0000_0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Max Input (2^64-1 * 1)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'd1;
        #1;

        check_outputs({64'h0, 64'hFFFF_FFFF_FFFF_FFFF});
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplication resulting in overflow of 64 bits", test_num);
        a = 64'hFFFF_FFFF_0000_0000;
        b = 64'h0000_0000_FFFF_FFFF;

        #1;


        check_outputs(128'h0000_0000_FFFF_FFFE_0000_0001_0000_0000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values (2^64-1 * 2^64-1)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'hFFFF_FFFF_FFFF_FFFF;

        #1;


        check_outputs(128'hFFFF_FFFF_FFFF_FFFE_0000_0000_0000_0001);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Prime-like Values", test_num);
        a = 64'hA5A5_A5A5_A5A5_A5A5;
        b = 64'h5A5A_5A5A_5A5A_5A5A;

        #1;


        check_outputs(128'h3A83_126E_978D_4FDF_C57A_EDB8_9172_5912);
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
