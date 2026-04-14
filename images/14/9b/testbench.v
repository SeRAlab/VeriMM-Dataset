`timescale 1ns/1ps

module multiplier_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_32bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero (0 * 0)", test_num);
        a = 32'h00000000;
        b = 32'h00000000;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Multiplication (12345678 * 1)", test_num);
        a = 32'h12345678;
        b = 32'h00000001;
        #1;

        check_outputs(64'h0000000012345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Small Multiplication (15 * 10)", test_num);
        a = 32'd15;
        b = 32'd10;
        #1;

        check_outputs(64'd150);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of Two (2^16 * 2^16)", test_num);
        a = 32'h00010000;
        b = 32'h00010000;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Unsigned (0x80000000 * 2)", test_num);
        a = 32'h80000000;
        b = 32'h00000002;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Values (0xFFFFFFFF * 0xFFFFFFFF)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;

        #1;


        check_outputs(64'hFFFFFFFF00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Prime Numbers (104729 * 99991)", test_num);
        a = 32'd104729;
        b = 32'd99991;
        #1;

        check_outputs(64'd10472052439);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits Pattern", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        #1;

        check_outputs(64'h38E38E388E38E38E);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Overflowing 32-bit boundary", test_num);
        a = 32'h00010001;
        b = 32'h00010001;
        #1;

        check_outputs(64'h0000000100020001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_32bit Testbench");
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
