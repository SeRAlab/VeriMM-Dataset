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
        test_num = test_num + 1;
        $display("Test %0d: Zero product (0.0 * 0.0)", test_num);
        a = 16'h0000;
        b = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity multiplication (1 * 1 in raw bits)", test_num);
        a = 16'h0001;
        b = 16'h0001;
        #1;

        check_outputs(32'h00000001);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Fixed-point 1.0 * 1.0 (assuming 8.8 format)", test_num);


        a = 16'h0100;
        b = 16'h0100;
        #1;

        check_outputs(32'h00010000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Fractional multiplication (0.5 * 0.5)", test_num);


        a = 16'h0080;
        b = 16'h0080;
        #1;

        check_outputs(32'h00004000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum value multiplication (0xFFFF * 0xFFFF)", test_num);

        a = 16'hFFFF;
        b = 16'hFFFF;
        #1;

        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mixed Integer and Fraction (1.5 * 2.0)", test_num);



        a = 16'h0180;
        b = 16'h0200;
        #1;

        check_outputs(32'h00030000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large range multiplication", test_num);

        a = 16'h1234;
        b = 16'h5678;
        #1;

        check_outputs(32'h06260060);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Bit pattern test (0xAAAA * 0x5555)", test_num);

        a = 16'hAAAA;
        b = 16'h5555;
        #1;

        check_outputs(32'h38E38E1E);
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
