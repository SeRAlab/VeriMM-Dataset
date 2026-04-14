`timescale 1ns/1ps

module multiplier_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_32bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero multiplication (0 * 0)", test_num);
            a = 32'h0;
            b = 32'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity multiplication (0x12345678 * 1)", test_num);
            a = 32'h12345678;
            b = 32'h1;
            #1;

            check_outputs(64'h0000000012345678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Multiplication by zero (0xFFFFFFFF * 0)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Maximum values (0xFFFFFFFF * 0xFFFFFFFF)", test_num);
            a = 32'hFFFFFFFF;
            b = 32'hFFFFFFFF;

            #1;


            check_outputs(64'hFFFFFFFE00000001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Power of 2 (0x00010000 * 0x00010000)", test_num);
            a = 32'h00010000;
            b = 32'h00010000;
            #1;

            check_outputs(64'h0000000100000000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: High/Low cross (0xFFFF0000 * 0x0000FFFF)", test_num);
            a = 32'hFFFF0000;
            b = 32'h0000FFFF;

            #1;


            check_outputs(64'h0000FFFEFFFF0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits (0xAAAAAAAA * 0x55555555)", test_num);
            a = 32'hAAAAAAAA;
            b = 32'h55555555;
            #1;

            check_outputs(64'h38E38E3871C71C72);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small primes (104729 * 104723)", test_num);
            a = 32'd104729;
            b = 32'd104723;
            #1;

            check_outputs(64'd10967530067);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow 32-bit (0x80000000 * 0x4)", test_num);
            a = 32'h80000000;
            b = 32'h4;
            #1;

            check_outputs(64'h0000000200000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random large values (0x12345678 * 0x87654321)", test_num);
            a = 32'h12345678;
            b = 32'h87654321;
            #1;

            check_outputs(64'h09A0A0B1290C7788);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_32bit Testbench");
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
