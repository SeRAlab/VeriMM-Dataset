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
            $display("\nTest Case %0d: Zero Multiplication", test_num);
            a = 32'h0;
            b = 32'h0;
            #10;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Multiply by One", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h1;
            #10;
            #1;

            check_outputs(64'h0000_0000_FFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Maximum Unsigned Values", test_num);

            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            #10;
            #1;

            check_outputs(64'hFFFF_FFFE_0000_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Small Values", test_num);
            a = 32'd1234;
            b = 32'd5678;
            #10;
            #1;

            check_outputs(64'd7006652);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Power of Two", test_num);
            a = 32'h0001_0000;
            b = 32'h0000_8000;
            #10;
            #1;

            check_outputs(64'h0000_0000_8000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Middle Range Values", test_num);
            a = 32'h1234_5678;
            b = 32'h8765_4321;
            #10;
            #1;

            check_outputs(64'h09A1_0044_B0B8_B678);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Alternating Bit Patterns", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            #10;
            #1;

            check_outputs(64'h38E3_8E38_71C7_1C76);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: One Input Zero, One Max", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'h0;
            #10;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Square of 16-bit Max", test_num);
            a = 32'h0000_FFFF;
            b = 32'h0000_FFFF;
            #10;
            #1;

            check_outputs(64'h0000_0000_FFFE_0001);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Large Numbers", test_num);
            a = 32'hDEAD_BEEF;
            b = 32'hCAFE_BABE;
            #10;
            #1;

            check_outputs(64'hB0AE_396F_6159_9922);
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
