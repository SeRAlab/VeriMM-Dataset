`timescale 1ns/1ps

module multiplier_64x64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64x64 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: All Zeros", test_num);
        a = 64'd0;
        b = 64'd0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Zero Multiplier", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'd0;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Identity Multiplication (A=1)", test_num);
        a = 64'd1;
        b = 64'hA5A5_B6B6_C7C7_D8D8;
        #1;

        check_outputs({64'h0, 64'hA5A5_B6B6_C7C7_D8D8});
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Identity Multiplication (B=1)", test_num);
        a = 64'h1234_5678_90AB_CDEF;
        b = 64'd1;
        #1;

        check_outputs({64'h0, 64'h1234_5678_90AB_CDEF});
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Power of 2 (Shift check)", test_num);
        a = 64'h0000_0001_0000_0000;
        b = 64'h0000_0001_0000_0000;
        #1;

        check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Maximum 32-bit values", test_num);
        a = 64'h0000_0000_FFFF_FFFF;
        b = 64'h0000_0000_FFFF_FFFF;

        #1;


        check_outputs(128'h0000_0000_0000_0000_FFFF_FFFE_0000_0001);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: High-bit Carry", test_num);
        a = 64'h8000_0000_0000_0000;
        b = 64'd2;
        #1;

        check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Pattern Multiplication", test_num);
        a = 64'h5555_5555_5555_5555;
        b = 64'h0000_0000_0000_0003;

        #1;


        check_outputs(128'h0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Arbitrary Large Values", test_num);
        a = 64'h1234_5678_1234_5678;
        b = 64'h0000_0000_0000_0002;
        #1;

        check_outputs(128'h0000_0000_0000_0000_2468_ACF0_2468_ACF0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Maximum 64-bit Unsigned", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'hFFFF_FFFF_FFFF_FFFF;


        #1;



        check_outputs(128'hFFFF_FFFF_FFFF_FFFE_0000_0000_0000_0001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64x64 Testbench");
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
