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
        $display("\nTest Case %0d: Zero inputs", test_num);
        a = 32'h00000000;
        b = 32'h00000000;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiplication by zero", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000000;
        #1;

        check_outputs(64'h0000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Multiplicative identity", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000001;
        #1;

        check_outputs(64'h00000000FFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Small integers", test_num);
        a = 32'd1234;
        b = 32'd5678;
        #1;

        check_outputs(64'd7006652);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Large range multiplication", test_num);
        a = 32'h00010000;
        b = 32'h00010000;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Maximum unsigned values", test_num);
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;

        #1;


        check_outputs(64'hFFFFFFFE00000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Bit pattern alternating", test_num);
        a = 32'hAAAAAAAA;
        b = 32'h55555555;

        #1;


        check_outputs(64'h38E38E3871C71C72);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Prime-like numbers", test_num);
        a = 32'd104729;
        b = 32'd224737;
        #1;

        check_outputs(64'd23536481273);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Boundary check (max 32-bit * small)", test_num);
        a = 32'hFFFFFFFF;
        b = 32'h00000002;
        #1;

        check_outputs(64'h00000001FFFFFFFE);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("\nTest Case %0d: Hex check", test_num);
        a = 32'h12345678;
        b = 32'h87654321;
        #1;

        check_outputs(64'h09A0A00A69696978);
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
