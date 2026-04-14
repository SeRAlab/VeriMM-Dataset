`timescale 1ns/1ps

module multiplier_8bit_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_8bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiply by zero (0 * 0)", test_num);
        a = 8'd0;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiply by zero (255 * 0)", test_num);
        a = 8'd255;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Multiply by one (1 * 123)", test_num);
        a = 8'd1;
        b = 8'd123;
        #1;

        check_outputs(16'd123);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Maximum values (255 * 255)", test_num);
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Power of two (16 * 16)", test_num);
        a = 8'd16;
        b = 8'd16;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Mid-range values (127 * 127)", test_num);
        a = 8'd127;
        b = 8'd127;
        #1;

        check_outputs(16'd16129);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Small primes (13 * 7)", test_num);
        a = 8'd13;
        b = 8'd7;
        #1;

        check_outputs(16'd91);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Arbitrary large values (200 * 50)", test_num);
        a = 8'd200;
        b = 8'd50;
        #1;

        check_outputs(16'd10000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Alternating bit pattern (170 * 85)", test_num);
        a = 8'hAA;
        b = 8'h55;
        #1;

        check_outputs(16'd14450);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Boundary value product (128 * 2)", test_num);
        a = 8'd128;
        b = 8'd2;
        #1;

        check_outputs(16'd256);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_8bit Testbench");
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
        input [15:0] expected_product;
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
