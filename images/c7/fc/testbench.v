`timescale 1ns/1ps

module xor_32_refactored_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    xor_32_refactored dut (
        .a(a),
        .b(b),
        .out(out)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 32'h00000000;
        b = 32'h00000000;
        $display("Test %0d: All zeros", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 32'h12345678;
        b = 32'h00000000;
        $display("Test %0d: Identity (A XOR 0)", test_num);
        #1;

        check_outputs(32'h12345678);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 32'hA5A5A5A5;
        b = 32'hA5A5A5A5;
        $display("Test %0d: Self-Annihilation (A XOR A)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 32'h00000000;
        b = 32'hFFFFFFFF;
        $display("Test %0d: Inversion (0 XOR 1s)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 32'h55555555;
        b = 32'hAAAAAAAA;
        $display("Test %0d: Alternating Patterns (55... XOR AA...)", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 32'h80000000;
        b = 32'h00000001;
        $display("Test %0d: Boundary Bits (MSB XOR LSB)", test_num);
        #1;

        check_outputs(32'h80000001);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 32'hF0F03333;
        b = 32'h0F0FCCCC;
        $display("Test %0d: Random Bitwise Patterns", test_num);
        #1;

        check_outputs(32'hFFFFFFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        a = 32'h00010000;
        b = 32'h00010000;
        $display("Test %0d: Walking One (overlapping bit)", test_num);
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("xor_32_refactored Testbench");
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
        input [31:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
