`timescale 1ns/1ps

module multiplier_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg enable;
    wire [63:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_32bit dut (
        .A(A),
        .B(B),
        .enable(enable),
        .product(product)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Multiplication (A=0, B=0, enable=1)", test_num);
            A = 32'd0;
            B = 32'd0;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Multiply by One (Identity property)", test_num);
            A = 32'h1234_5678;
            B = 32'd1;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(64'h0000_0000_1234_5678);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Small Values (15 * 15)", test_num);
            A = 32'd15;
            B = 32'd15;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(64'd225);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Unsigned Values (2^32-1 * 2^32-1)", test_num);
            A = 32'hFFFF_FFFF;
            B = 32'hFFFF_FFFF;
            enable = 1'b1;
            #10;

            #1;


            check_outputs(64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Large Value and Small Value", test_num);
            A = 32'hABCDE_000;
            B = 32'h0000_0123;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(64'hABCDE_000 * 64'h123);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Enable Disabled (Check gating behavior)", test_num);

            A = 32'd10;
            B = 32'd10;
            enable = 1'b1;
            #10;



            A = 32'd50;
            B = 32'd50;
            enable = 1'b0;
            #10;
            #1;

            check_outputs(64'd0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Random Prime Numbers", test_num);
            A = 32'd104729;
            B = 32'd7919;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(64'd829348951);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Overflow Check (Product > 2^32)", test_num);
            A = 32'h8000_0000;
            B = 32'h0000_0004;
            enable = 1'b1;
            #10;
            #1;

            check_outputs(64'h0000_0002_0000_0000);
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
