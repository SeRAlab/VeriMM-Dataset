`timescale 1ns/1ps

module booth_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] multiplicand;
    reg [3:0] multiplier;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    booth_multiplier dut (
        .multiplicand(multiplicand),
        .multiplier(multiplier),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive * Positive (3 * 2)", test_num);
        multiplicand = 4'sd3;
        multiplier   = 4'sd2;
        #1;

        check_outputs(8'sd6);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive * Negative (3 * -2)", test_num);
        multiplicand = 4'sd3;
        multiplier   = -4'sd2;
        #1;

        check_outputs(-8'sd6);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative * Positive (-3 * 2)", test_num);
        multiplicand = -4'sd3;
        multiplier   = 4'sd2;
        #1;

        check_outputs(-8'sd6);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative * Negative (-3 * -2)", test_num);
        multiplicand = -4'sd3;
        multiplier   = -4'sd2;
        #1;

        check_outputs(8'sd6);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Multiplicand (0 * 7)", test_num);
        multiplicand = 4'sd0;
        multiplier   = 4'sd7;
        #1;

        check_outputs(8'sd0);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Multiplier (-5 * 0)", test_num);
        multiplicand = -4'sd5;
        multiplier   = 4'sd0;
        #1;

        check_outputs(8'sd0);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Positive (7 * 7)", test_num);
        multiplicand = 4'sd7;
        multiplier   = 4'sd7;
        #1;

        check_outputs(8'sd49);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Minimum Negative and Max Positive (-8 * 7)", test_num);
        multiplicand = -4'sd8;
        multiplier   = 4'sd7;
        #1;

        check_outputs(-8'sd56);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Negative * Max Negative (-8 * -8)", test_num);
        multiplicand = -4'sd8;
        multiplier   = -4'sd8;
        #1;

        check_outputs(8'sd64);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiply by 1 (5 * 1)", test_num);
        multiplicand = 4'sd5;
        multiplier   = 4'sd1;
        #1;

        check_outputs(8'sd5);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiply by -1 (-1 * -1)", test_num);
        multiplicand = -4'sd1;
        multiplier   = -4'sd1;
        #1;

        check_outputs(8'sd1);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Pattern (5 * -3)", test_num);
        multiplicand = 4'b0101;
        multiplier   = 4'b1101;
        #1;

        check_outputs(-8'sd15);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("booth_multiplier Testbench");
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
        testcase011();
        testcase012();
        
        
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
        input [7:0] expected_product;
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
