`timescale 1ns/1ps

module signed_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    signed_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Zero multiplication", test_num);
        a = 64'd0;
        b = 64'd123456789;
        #1;
        #1;

        check_outputs(128'd0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive x Positive", test_num);
        a = 64'd1000;
        b = 64'd500;
        #1;
        #1;

        check_outputs(128'd500000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Positive x Negative", test_num);
        a = 64'd10;
        b = -64'd5;
        #1;
        #1;

        check_outputs(-128'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Negative x Negative", test_num);
        a = -64'd12;
        b = -64'd12;
        #1;
        #1;

        check_outputs(128'd144);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Positive x 2", test_num);
        a = 64'h7FFFFFFFFFFFFFFF;
        b = 64'd2;
        #1;

        #1;


        check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Negative x 1", test_num);
        a = 64'h8000000000000000;
        b = 64'd1;
        #1;

        #1;


        check_outputs(128'hFFFFFFFFFFFFFFFF8000000000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Negative x -1", test_num);
        a = 64'h8000000000000000;
        b = -64'd1;
        #1;

        #1;


        check_outputs(128'h00000000000000008000000000000000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Positive x Large Positive", test_num);
        a = 64'h0000000100000000;
        b = 64'h0000000100000000;
        #1;

        #1;


        check_outputs(128'h00000000000000010000000000000000);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Positive Squared", test_num);
        a = 64'h7FFFFFFFFFFFFFFF;
        b = 64'h7FFFFFFFFFFFFFFF;
        #1;

        #1;


        check_outputs(128'h3FFFFFFFFFFFFFFF0000000000000001);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: -1 x -1", test_num);
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;
        #1;
        #1;

        check_outputs(128'h00000000000000000000000000000001);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("signed_multiplier Testbench");
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
        input [127:0] expected_product;
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
