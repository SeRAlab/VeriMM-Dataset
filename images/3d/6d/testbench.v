`timescale 1ns/1ps

module multiplier_32x32_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    reg valid;
    wire ready;
    wire [63:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_32x32 dut (
        .a(a),
        .b(b),
        .valid(valid),
        .ready(ready),
        .result(result)
    );
    task testcase001;

    begin
        $display("Testcase 001: Zero multiplication (0 x 0)");
        test_num = 1;
        a = 32'd0;
        b = 32'd0;
        valid = 1'b1;
        #1;

        check_outputs(1'b1, 64'd0);
    end
        endtask

    task testcase002;

    begin
        $display("Testcase 002: Identity multiplication (0x12345678 x 1)");
        test_num = 2;
        a = 32'h12345678;
        b = 32'h1;
        valid = 1'b1;
        #1;

        check_outputs(1'b1, 64'h12345678);
    end
        endtask

    task testcase003;

    begin
        $display("Testcase 003: Maximum unsigned values (0xFFFFFFFF x 0xFFFFFFFF)");
        test_num = 3;
        a = 32'hFFFFFFFF;
        b = 32'hFFFFFFFF;
        valid = 1'b1;

        #1;


        check_outputs(1'b1, 64'hFFFFFFFF00000001);
    end
        endtask

    task testcase004;

    begin
        $display("Testcase 004: Mid-range value multiplication");
        test_num = 4;
        a = 32'h0000ABCD;
        b = 32'h00001234;
        valid = 1'b1;

        #1;


        check_outputs(1'b1, 64'h000000000C375F24);
    end
        endtask

    task testcase005;

    begin
        $display("Testcase 005: Power of 2 (Shift test)");
        test_num = 5;
        a = 32'h00010000;
        b = 32'h00010000;
        valid = 1'b1;

        #1;


        check_outputs(1'b1, 64'h0000000100000000);
    end
        endtask

    task testcase006;

    begin
        $display("Testcase 006: Large arbitrary numbers");
        test_num = 6;
        a = 32'h12345678;
        b = 32'h87654321;
        valid = 1'b1;


        #1;



        check_outputs(1'b1, 64'h09A0A1F08F1BB278);
    end
        endtask

    task testcase007;

    begin
        $display("Testcase 007: Valid signal low check");
        test_num = 7;
        a = 32'hA5A5A5A5;
        b = 32'h5A5A5A5A;
        valid = 1'b0;

        #1;


        check_outputs(1'b0, result);
    end
        endtask

    task testcase008;

    begin
        $display("Testcase 008: Large prime-like numbers");
        test_num = 8;
        a = 32'hDEADC0DE;
        b = 32'hBEEFBABE;
        valid = 1'b1;

        #1;


        check_outputs(1'b1, 64'hA66136AD92164554);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_32x32 Testbench");
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
        input expected_ready;
        input [63:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ready === (expected_ready ^ ready ^ expected_ready) &&
                expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: ready=%b, result=%h",
                         ready, result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ready=%b, result=%h",
                         expected_ready, expected_result);
                $display("  Got:      ready=%b, result=%h",
                         ready, result);
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
