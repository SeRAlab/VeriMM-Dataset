`timescale 1ns/1ps

module multiplier_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_16bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Multiplication (0 * 0)", test_num);
        a = 16'h0000;
        b = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity (FFFF * 1)", test_num);
        a = 16'hFFFF;
        b = 16'h0001;
        #1;

        check_outputs(32'h0000FFFF);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Small Values (000F * 000F)", test_num);
        a = 16'h000F;
        b = 16'h000F;
        #1;

        check_outputs(32'd225);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Powers of 2 (0100 * 0100)", test_num);
        a = 16'h0100;
        b = 16'h0100;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum Values (FFFF * FFFF)", test_num);
        a = 16'hFFFF;
        b = 16'hFFFF;

        #1;


        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Alternating Bit Patterns (AAAA * 5555)", test_num);
        a = 16'hAAAA;
        b = 16'h5555;
        #1;

        check_outputs(32'h38E38E1E);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large Prime Multiplication", test_num);
        a = 16'd1049;
        b = 16'd2039;
        #1;

        check_outputs(32'd2138911);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Half-scale Values (7FFF * 7FFF)", test_num);
        a = 16'h7FFF;
        b = 16'h7FFF;
        #1;

        check_outputs(32'h3FFF0001);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Zero Operand B (ABCD * 0)", test_num);
        a = 16'hABCD;
        b = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large and Small (C000 * 0004)", test_num);
        a = 16'hC000;
        b = 16'h0004;
        #1;

        check_outputs(32'h00030000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_16bit Testbench");
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
