`timescale 1ns/1ps

module multiplier_32_to_64_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_32_to_64 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 32'h0;
        b = 32'h0;
        $display("Test %0d: 0 * 0", test_num);
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 32'hFFFFFFFF;
        b = 32'h0;
        $display("Test %0d: Max value * 0", test_num);
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 32'h1;
        b = 32'h12345678;
        $display("Test %0d: 1 * Identity", test_num);
        #1;

        check_outputs(64'h0000000012345678);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 32'hA;
        b = 32'h14;
        $display("Test %0d: Small numbers (10 * 20)", test_num);
        #1;

        check_outputs(64'd200);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 32'h00010000;
        b = 32'h00010000;
        $display("Test %0d: Powers of 2 (2^16 * 2^16)", test_num);
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        $display("Test %0d: Maximum 32-bit values", test_num);

        #1;


        check_outputs(64'hFFFFFFFE00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 32'h80000000;
        b = 32'h2;
        $display("Test %0d: MSB shift", test_num);
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        $display("Test %0d: Alternating bit patterns", test_num);
        #1;

        check_outputs(64'h38E38E3871C71C7E);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        a = 32'hDEADBEEF;
        b = 32'hCAFEBABE;
        $display("Test %0d: Large hex values", test_num);
        #1;

        check_outputs(64'hB0712A6899416412);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        a = 32'd123456789;
        b = 32'd987654321;
        $display("Test %0d: Large decimal values", test_num);
        #1;

        check_outputs(64'd121932631112635269);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_32_to_64 Testbench");
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
