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
        test_num = 1;
        $display("Test Case 001: Zero multiplication (0 x 0)");
        a = 8'd0;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Identity multiplication (1 x 1)");
        a = 8'd1;
        b = 8'd1;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Maximum values (255 x 255)");
        a = 8'hFF;
        b = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Multiplication by zero (255 x 0)");
        a = 8'hFF;
        b = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Power of two (16 x 32)");
        a = 8'd16;
        b = 8'd32;
        #1;

        check_outputs(16'd512);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Small primes (13 x 17)");
        a = 8'd13;
        b = 8'd17;
        #1;

        check_outputs(16'd221);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Mid-range values (123 x 45)");
        a = 8'd123;
        b = 8'd45;
        #1;

        check_outputs(16'd5535);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Alternating bit patterns (0xAA x 0x55)");
        a = 8'hAA;
        b = 8'h55;
        #1;

        check_outputs(16'd14450);
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
