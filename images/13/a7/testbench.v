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
        test_num = 1;
        $display("Test Case 001: Zero multiplication");
        a = 32'h00000000; b = 32'h00000000;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case 002: Operand B is zero");
        a = 32'h12345678; b = 32'h00000000;
        #1;

        check_outputs(64'h0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case 003: Identity (1) multiplication");
        a = 32'hFFFFFFFF; b = 32'h00000001;
        #1;

        check_outputs(64'h00000000FFFFFFFF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case 004: Max * Max");
        a = 32'hFFFFFFFF; b = 32'hFFFFFFFF;

        #1;


        check_outputs(64'hFFFFFFFE00000001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case 005: Power of 2 multiplication");
        a = 32'h00010000; b = 32'h00010000;
        #1;

        check_outputs(64'h0000000100000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case 006: Bit patterns (0xAAAA... * 0x5555...)");
        a = 32'hAAAAAAAA; b = 32'h55555555;
        #1;

        check_outputs(64'h38E38E3871C71C72);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case 007: Small values (1234 * 5678)");
        a = 32'h00001234; b = 32'h00005678;
        #1;

        check_outputs(64'h0000000006247080);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case 008: Large values");
        a = 32'hDEADBEEF; b = 32'hCAFEBABE;
        #1;

        check_outputs(64'hB0AF457224213B12);
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
