`timescale 1ns/1ps

module multiplier_64x64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;
    wire valid;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64x64 dut (
        .a(a),
        .b(b),
        .product(product),
        .valid(valid)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Multiplication (0 * 0)", test_num);
        a = 64'h0;
        b = 64'h0;

        #1;


        check_outputs(128'h0, 1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Zero Multiplication (Max * 0)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h0;

        #1;


        check_outputs(128'h0, 1'b1);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity Multiplication (1 * 1)", test_num);
        a = 64'h1;
        b = 64'h1;

        #1;


        check_outputs(128'h1, 1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Identity Multiplication (Max * 1)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'h1;

        #1;


        check_outputs(128'h0000_0000_0000_0000_FFFF_FFFF_FFFF_FFFF, 1'b1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power of 2 Multiplication (2^32 * 2^32)", test_num);
        a = 64'h0000_0001_0000_0000;
        b = 64'h0000_0001_0000_0000;

        #1;


        check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Result exceeding 64 bits (2^63 * 2)", test_num);
        a = 64'h8000_0000_0000_0000;
        b = 64'h2;

        #1;


        check_outputs(128'h0000_0000_0000_0001_0000_0000_0000_0000, 1'b1);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range value (2^32-1)^2", test_num);
        a = 64'h0000_0000_FFFF_FFFF;
        b = 64'h0000_0000_FFFF_FFFF;

        #1;


        check_outputs(128'h0000_0000_0000_0000_FFFF_FFFE_0000_0001, 1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum Values (Max * Max)", test_num);
        a = 64'hFFFF_FFFF_FFFF_FFFF;
        b = 64'hFFFF_FFFF_FFFF_FFFF;

        #1;


        check_outputs(128'hFFFF_FFFF_FFFF_FFFE_0000_0000_0000_0001, 1'b1);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Patterned Multiplication", test_num);
        a = 64'hAAAA_AAAA_AAAA_AAAA;
        b = 64'h2;

        #1;


        check_outputs(128'h0000_0000_0000_0001_5555_5555_5555_5554, 1'b1);
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
        input expected_valid;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_product === (expected_product ^ product ^ expected_product) &&
                expected_valid === (expected_valid ^ valid ^ expected_valid)) begin
                $display("PASS");
                $display("  Outputs: product=%h, valid=%b",
                         product, valid);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: product=%h, valid=%b",
                         expected_product, expected_valid);
                $display("  Got:      product=%h, valid=%b",
                         product, valid);
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
