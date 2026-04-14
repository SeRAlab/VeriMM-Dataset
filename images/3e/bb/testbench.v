`timescale 1ns/1ps

module multiplier_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [127:0] product;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_64bit dut (
        .a(a),
        .b(b),
        .product(product)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Zero check", test_num);
        a = 64'h0;
        b = 64'hFFFFFFFFFFFFFFFF;
        #1;

        check_outputs(128'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Identity check", test_num);
        a = 64'hFEDCBA9876543210;
        b = 64'h1;
        #1;

        check_outputs(128'h0000000000000000FEDCBA9876543210);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Small integers", test_num);
        a = 64'd12345;
        b = 64'd67890;

        #1;


        check_outputs(128'h00000000000000000000000031F1D222);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Maximum values", test_num);
        a = 64'hFFFFFFFFFFFFFFFF;
        b = 64'hFFFFFFFFFFFFFFFF;


        #1;



        check_outputs(128'hFFFFFFFFFFFFFFFE0000000000000001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Power of 2 (2^63 * 2)", test_num);
        a = 64'h8000000000000000;
        b = 64'h2;

        #1;


        check_outputs(128'h00000000000000010000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Mid-point carry", test_num);
        a = 64'h8000000000000000;
        b = 64'h8000000000000000;


        #1;



        check_outputs(128'h40000000000000000000000000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Alternating bit patterns", test_num);
        a = 64'hAAAAAAAAAAAAAAAA;
        b = 64'h5555555555555555;

        #1;


        check_outputs(128'h38E38E38E38E38E31C71C71C71C71C72);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTestcase %0d: Large complex numbers", test_num);
        a = 64'h123456789ABCDEF0;
        b = 64'h0FEDCBA987654321;

        #1;


        check_outputs(128'h00121FB4A307049E29A8A72A901507F0);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_64bit Testbench");
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
