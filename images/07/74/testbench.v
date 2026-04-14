`timescale 1ns/1ps

module multiplier64_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier64 dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

        begin
            $display("Running testcase001: Multiplication by Zero...");
            test_num = test_num + 1;


            a = 64'd0;
            b = 64'd0;
            #1;

            check_outputs(128'd0);


            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'd0;
            #1;

            check_outputs(128'd0);


            a = 64'd0;
            b = 64'h123456789ABCDEF0;
            #1;

            check_outputs(128'd0);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Identity Property...");
            test_num = test_num + 1;


            a = 64'd1;
            b = 64'd1;
            #1;

            check_outputs(128'd1);


            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'd1;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFF);


            a = 64'd1;
            b = 64'h5A5A5A5A5A5A5A5A;
            #1;

            check_outputs(128'h5A5A5A5A5A5A5A5A);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Maximum Values...");
            test_num = test_num + 1;



            a = 64'hFFFFFFFFFFFFFFFF;
            b = 64'hFFFFFFFFFFFFFFFF;
            #1;

            check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Powers of 2...");
            test_num = test_num + 1;


            a = 64'h8000000000000000;
            b = 64'd2;
            #1;

            check_outputs(128'h00000000000000010000000000000000);


            a = 64'h0000000100000000;
            b = 64'h0000000100000000;
            #1;

            check_outputs(128'h00000000000000010000000000000000);



            a = 64'h8000000000000000;
            b = 64'h8000000000000000;
            #1;

            check_outputs(128'h40000000000000000000000000000000);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: 32-bit Boundaries...");
            test_num = test_num + 1;


            a = 64'h00000000FFFFFFFF;
            b = 64'h00000000FFFFFFFF;
            #1;

            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFE00000001);
        end
        endtask

    task testcase006;

        begin
            $display("Running testcase006: Alternating Bit Patterns...");
            test_num = test_num + 1;


            a = 64'hAAAAAAAAAAAAAAAA;
            b = 64'h0000000000000002;
            #1;

            check_outputs(128'h00000000000000015555555555555554);



            a = 64'h5555555555555555;
            b = 64'h0000000000000003;
            #1;

            check_outputs(128'h0000000000000000FFFFFFFFFFFFFFFF);
        end
        endtask

    task testcase007;

        begin
            $display("Running testcase007: Medium Arbitrary Values...");
            test_num = test_num + 1;


            a = 64'h0000000012345678;
            b = 64'h0000000087654321;
            #1;

            check_outputs(128'h0000000000000000099B3037D3C77E88);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier64 Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
