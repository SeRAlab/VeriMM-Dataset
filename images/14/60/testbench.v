`timescale 1ns/1ps

module multiplier_64x64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64x64 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest %0d: Zero Inputs", test_num);
            a = 64'd0;
            b = 64'd0;
            #1;

            check_outputs(128'd0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest %0d: Multiplication by Zero", test_num);
            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'd0;
            #1;

            check_outputs(128'd0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest %0d: Multiplication by One (Identity)", test_num);
            a = 64'h123456789ABCDEF0;
            b = 64'd1;
            #1;

            check_outputs(128'h0000000000000000123456789ABCDEF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest %0d: Simple Power of 2 (Shift Check)", test_num);
            a = 64'h0000000000000001;
            b = 64'h8000000000000000;
            #1;

            check_outputs(128'h00000000000000008000000000000000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest %0d: Maximum Values (All Fs)", test_num);

            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("\nTest %0d: Large Square (32-bit boundary)", test_num);
            a = 64'h0000000100000000;
            b = 64'h0000000100000000;
            #1;

            check_outputs(128'h00000000000000010000000000000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("\nTest %0d: Alternating Bits", test_num);
            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h5555555555555555;

            #1;


            check_outputs(128'h38E38E38E38E38E31C71C71C71C71C72);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("\nTest %0d: Carry Propagations", test_num);
            a = 64'h7FFFFFFFFFFFFFFF;
            b = 64'h0000000000000002;
            #1;

            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFE);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("\nTest %0d: Small Prime Product", test_num);
            a = 64'd123456789;
            b = 64'd987654321;
            #1;

            check_outputs(128'd121932631112635269);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("\nTest %0d: Large Hex Constants", test_num);
            a = 64'hFEEDFACECAFEBEEF;
            b = 64'h1234567890ABCDEF;
            #1;

            check_outputs(128'h1220496B55E5901F6E1C5808B67B5471);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64x64 Testbench");
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
