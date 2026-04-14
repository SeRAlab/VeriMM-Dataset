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
        test_num = 1;
        $display("Test %0d: 0 * 0", test_num);
        multiplicand = 4'b0000;
        multiplier   = 4'b0000;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test %0d: 3 * 2", test_num);
        multiplicand = 4'b0011;
        multiplier   = 4'b0010;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test %0d: 7 * 7", test_num);
        multiplicand = 4'b0111;
        multiplier   = 4'b0111;
        #1;

        check_outputs(8'h31);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test %0d: 5 * -3", test_num);
        multiplicand = 4'b0101;
        multiplier   = 4'b1101;
        #1;

        check_outputs(8'hF1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test %0d: -4 * 2", test_num);
        multiplicand = 4'b1100;
        multiplier   = 4'b0010;
        #1;

        check_outputs(8'hF8);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test %0d: -2 * -3", test_num);
        multiplicand = 4'b1110;
        multiplier   = 4'b1101;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test %0d: -1 * -1", test_num);
        multiplicand = 4'b1111;
        multiplier   = 4'b1111;
        #1;

        check_outputs(8'h01);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test %0d: -8 * 7", test_num);
        multiplicand = 4'b1000;
        multiplier   = 4'b0111;
        #1;

        check_outputs(8'hC8);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test %0d: 7 * -8", test_num);
        multiplicand = 4'b0111;
        multiplier   = 4'b1000;
        #1;

        check_outputs(8'hC8);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test %0d: -8 * -8", test_num);
        multiplicand = 4'b1000;
        multiplier   = 4'b1000;
        #1;

        check_outputs(8'h40);
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
