`timescale 1ns/1ps

module binary_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] a;
    reg [3:0] b;
    wire [7:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    binary_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 4'd0; b = 4'd0;
        $display("Test %0d: Multiplication by Zero (0 * 0)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 4'd15; b = 4'd0;
        $display("Test %0d: Multiplication by Zero (15 * 0)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 4'd0; b = 4'd15;
        $display("Test %0d: Multiplication by Zero (0 * 15)", test_num);
        #1;

        check_outputs(8'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 4'd1; b = 4'd1;
        $display("Test %0d: Identity (1 * 1)", test_num);
        #1;

        check_outputs(8'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 4'd15; b = 4'd1;
        $display("Test %0d: Identity (15 * 1)", test_num);
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 4'd3; b = 4'd5;
        $display("Test %0d: Small Values (3 * 5)", test_num);
        #1;

        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 4'd10; b = 4'd10;
        $display("Test %0d: Mid-range Values (10 * 10)", test_num);
        #1;

        check_outputs(8'd100);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 4'd7; b = 4'd8;
        $display("Test %0d: Power of Two (7 * 8)", test_num);
        #1;

        check_outputs(8'd56);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 4'd12; b = 4'd9;
        $display("Test %0d: Mixed Values (12 * 9)", test_num);
        #1;

        check_outputs(8'd108);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 4'd15; b = 4'd15;
        $display("Test %0d: Maximum Values (15 * 15)", test_num);
        #1;

        check_outputs(8'd225);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("binary_multiplier Testbench");
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
