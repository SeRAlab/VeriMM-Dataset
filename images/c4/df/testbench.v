`timescale 1ns/1ps

module four_bit_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] x;
    reg [3:0] y;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    four_bit_multiplier dut (
        .x(x),
        .y(y),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplying by zero (0 x 0)", test_num);
        x = 4'd0;
        y = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Multiplying by zero (15 x 0)", test_num);
        x = 4'd15;
        y = 4'd0;
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Identity property (1 x 10)", test_num);
        x = 4'd1;
        y = 4'd10;
        #1;

        check_outputs(8'd10);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Simple multiplication (3 x 4)", test_num);
        x = 4'd3;
        y = 4'd4;
        #1;

        check_outputs(8'd12);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Maximum values (15 x 15)", test_num);
        x = 4'd15;
        y = 4'd15;
        #1;

        check_outputs(8'd225);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Powers of two (8 x 4)", test_num);
        x = 4'd8;
        y = 4'd4;
        #1;

        check_outputs(8'd32);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Prime numbers (13 x 11)", test_num);
        x = 4'd13;
        y = 4'd11;
        #1;

        check_outputs(8'd143);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Commutative property (5 x 9)", test_num);
        x = 4'd5;
        y = 4'd9;
        #1;

        check_outputs(8'd45);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Commutative property (9 x 5)", test_num);
        x = 4'd9;
        y = 4'd5;
        #1;

        check_outputs(8'd45);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test Case %0d: Large result (14 x 10)", test_num);
        x = 4'd14;
        y = 4'd10;
        #1;

        check_outputs(8'd140);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("four_bit_multiplier Testbench");
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
