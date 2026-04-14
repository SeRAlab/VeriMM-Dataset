`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Multiplicand;
    reg [7:0] Multiplier;
    wire [15:0] Product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Multiplicand(Multiplicand),
        .Multiplier(Multiplier),
        .Product(Product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Case (0 * 0)", test_num);
        Multiplicand = 8'd0;
        Multiplier = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Multiplier (255 * 0)", test_num);
        Multiplicand = 8'd255;
        Multiplier = 8'd0;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero Multiplicand (0 * 255)", test_num);
        Multiplicand = 8'd0;
        Multiplier = 8'd255;
        #1;

        check_outputs(16'd0);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Case (1 * 1)", test_num);
        Multiplicand = 8'd1;
        Multiplier = 8'd1;
        #1;

        check_outputs(16'd1);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Multiplier (123 * 1)", test_num);
        Multiplicand = 8'd123;
        Multiplier = 8'd1;
        #1;

        check_outputs(16'd123);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values (255 * 255)", test_num);
        Multiplicand = 8'hFF;
        Multiplier = 8'hFF;
        #1;

        check_outputs(16'hFE01);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Power of Two (128 * 2)", test_num);
        Multiplicand = 8'd128;
        Multiplier = 8'd2;
        #1;

        check_outputs(16'd256);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Prime Numbers (13 * 17)", test_num);
        Multiplicand = 8'd13;
        Multiplier = 8'd17;
        #1;

        check_outputs(16'd221);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-range Values (123 * 45)", test_num);
        Multiplicand = 8'd123;
        Multiplier = 8'd45;
        #1;

        check_outputs(16'd5535);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Binary Alignment (15 * 15)", test_num);
        Multiplicand = 8'h0F;
        Multiplier = 8'h0F;
        #1;

        check_outputs(16'h00E1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [15:0] expected_Product;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Product === (expected_Product ^ Product ^ expected_Product)) begin
                $display("PASS");
                $display("  Outputs: Product=%h",
                         Product);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Product=%h",
                         expected_Product);
                $display("  Got:      Product=%h",
                         Product);
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
