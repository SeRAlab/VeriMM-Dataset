`timescale 1ns/1ps

module fixed_point_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    wire [31:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    fixed_point_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Zero multiplication (0.0 * 0.0)", test_num);
            a = 16'h0000;
            b = 16'h0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Positive square (0.5 * 0.5 = 0.25)", test_num);
            a = 16'h4000;
            b = 16'h4000;
            #1;

            check_outputs(32'h2000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Signed multiplication (-0.5 * 0.5 = -0.25)", test_num);
            a = 16'hC000;
            b = 16'h4000;
            #1;

            check_outputs(32'hE000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Negative square (-0.5 * -0.5 = 0.25)", test_num);
            a = 16'hC000;
            b = 16'hC000;
            #1;

            check_outputs(32'h2000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Maximum positive values (~1.0 * ~1.0)", test_num);
            a = 16'h7FFF;
            b = 16'h7FFF;
            #1;

            check_outputs(32'h7FFE_0002);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Minimum values (-1.0 * -1.0 = 1.0/Overflow)", test_num);
            a = 16'h8000;
            b = 16'h8000;

            #1;


            check_outputs(32'h8000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Min/Max boundary (-1.0 * ~1.0)", test_num);
            a = 16'h8000;
            b = 16'h7FFF;
            #1;

            check_outputs(32'h8001_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Smallest non-zero product", test_num);
            a = 16'h0001;
            b = 16'h0001;
            #1;

            check_outputs(32'h0000_0002);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Test %0d: Mixed Magnitude (-1.0 * 2^-15)", test_num);
            a = 16'h8000;
            b = 16'h0001;
            #1;

            check_outputs(32'hFFFF_0000);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Test %0d: Small negative identity (-2^-15 * 0.5)", test_num);
            a = 16'hFFFF;
            b = 16'h4000;
            #1;

            check_outputs(32'hFFFF_8000);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("fixed_point_multiplier Testbench");
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
