`timescale 1ns/1ps

module unsigned_multiplier_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    unsigned_multiplier dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Zero Multiplier (0 * 0)", test_num);
        a = 32'h0;
        b = 32'h0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Zero Multiplier with Max value (FFFFFFFF * 0)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h0;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Unity Multiplier (1 * 1)", test_num);
        a = 32'h1;
        b = 32'h1;
        #1;

        check_outputs(64'h1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Max value multiplied by 1 (FFFFFFFF * 1)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h1;
        #1;

        check_outputs(64'h00000000FFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Max value squared (FFFFFFFF * FFFFFFFF)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        #1;

        check_outputs(64'hFFFFFFFE00000001);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Medium range constants", test_num);
        a = 32'h12345678;
        b = 32'h87654321;
        #1;

        check_outputs(64'h09A0B10AE0705C68);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Power of 2 multiplication", test_num);
        a = 32'h00010000;
        b = 32'h00010000;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Alternating bit patterns (AAAA... * 5555...)", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;
        #1;

        check_outputs(64'h38E38E3871C71C72);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Test Case %0d: Large product overflowing 32-bit", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000002;
        #1;

        check_outputs(64'h00000001FFFFFFFE);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Test Case %0d: Small primes (13 * 17)", test_num);
        a = 32'd13;
        b = 32'd17;
        #1;

        check_outputs(64'd221);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("unsigned_multiplier Testbench");
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
        input [63:0] expected_product;
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
