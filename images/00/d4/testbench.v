`timescale 1ns/1ps

module float_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    float_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1.0 * 1.0 = 1.0", test_num);
            a = 32'h3f800000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h3f800000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 2.0 * 2.5 = 5.0", test_num);
            a = 32'h40000000;
            b = 32'h40200000;
            #1;

            check_outputs(32'h40a00000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -1.5 * 4.0 = -6.0", test_num);
            a = 32'hbfc00000;
            b = 32'h40800000;
            #1;

            check_outputs(32'hc0c00000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1.25 * 0.5 = 0.625 (Normalization shift right)", test_num);
            a = 32'h3fa00000;
            b = 32'h3f000000;
            #1;

            check_outputs(32'h3f200000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 0.0 * 5.5 = 0.0", test_num);
            a = 32'h00000000;
            b = 32'h40b00000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: -2.0 * -3.0 = 6.0 (Negative * Negative)", test_num);
            a = 32'hc0000000;
            b = 32'hc0400000;
            #1;

            check_outputs(32'h40c00000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Infinity * 1.0 = Infinity", test_num);
            a = 32'h7f800000;
            b = 32'h3f800000;
            #1;

            check_outputs(32'h7f800000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: 1.875 * 1.5 = 2.8125 (Normalization shift left check)", test_num);

            a = 32'h3ff00000;
            b = 32'h3fc00000;
            #1;

            check_outputs(32'h40340000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("float_multiplier Testbench");
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
