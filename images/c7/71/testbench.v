`timescale 1ns/1ps

module adder_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    reg cin;
    wire [31:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder dut (
        .A(A),
        .B(B),
        .cin(cin),
        .sum(sum)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (No Carry-in)", test_num);
        A = 32'h0000_0005;
        B = 32'h0000_000A;
        cin = 1'b0;
        #1;

        check_outputs(32'h0000_000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Basic Addition (With Carry-in)", test_num);
        A = 32'h0000_0005;
        B = 32'h0000_000A;
        cin = 1'b1;
        #1;

        check_outputs(32'h0000_0010);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        cin = 1'b0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Value Overflow (Wrapping)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        cin = 1'b0;
        #1;

        check_outputs(32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Max Value with Carry-in", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        cin = 1'b1;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bits Logic", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        cin = 1'b0;
        #1;

        check_outputs(32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Half-word Addition", test_num);
        A = 32'h1234_0000;
        B = 32'h0000_5678;
        cin = 1'b1;
        #1;

        check_outputs(32'h1234_5679);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Value Carry Propagation", test_num);
        A = 32'h7FFF_FFFF;
        B = 32'h0000_0001;
        cin = 1'b0;
        #1;

        check_outputs(32'h8000_0000);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder Testbench");
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
        input [31:0] expected_sum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_sum === (expected_sum ^ sum ^ expected_sum)) begin
                $display("PASS");
                $display("  Outputs: sum=%h",
                         sum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: sum=%h",
                         expected_sum);
                $display("  Got:      sum=%h",
                         sum);
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
