`timescale 1ns/1ps

module adder_32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] A;
    reg [31:0] B;
    wire C32;
    wire [31:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_32bit dut (
        .A(A),
        .B(B),
        .C32(C32),
        .S(S)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: All Zeros", test_num);
        A = 32'h0000_0000;
        B = 32'h0000_0000;
        #1;

        check_outputs(1'b0, 32'h0000_0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Simple Addition", test_num);
        A = 32'h1234_5678;
        B = 32'h1111_1111;
        #1;

        check_outputs(1'b0, 32'h2345_6789);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Mid-point Carry Propagation (16-bit boundary)", test_num);
        A = 32'h0000_FFFF;
        B = 32'h0000_0001;
        #1;

        check_outputs(1'b0, 32'h0001_0000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Final Carry-out (C32)", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'h0000_0001;
        #1;

        check_outputs(1'b1, 32'h0000_0000);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum Values", test_num);
        A = 32'hFFFF_FFFF;
        B = 32'hFFFF_FFFF;
        #1;

        check_outputs(1'b1, 32'hFFFF_FFFE);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Alternating Bit Patterns", test_num);
        A = 32'hAAAA_AAAA;
        B = 32'h5555_5555;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Carry into MSB", test_num);
        A = 32'h7FFF_FFFF;
        B = 32'h0000_0001;
        #1;

        check_outputs(1'b0, 32'h8000_0000);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Complex Hex Pattern with Carry", test_num);
        A = 32'hDEAD_BEEF;
        B = 32'hCAFE_BABE;

        #1;


        check_outputs(1'b1, 32'hA9AB_69AD);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Identity Property", test_num);
        A = 32'h8765_4321;
        B = 32'h0000_0000;
        #1;

        check_outputs(1'b0, 32'h8765_4321);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large Addition No Carry-out", test_num);
        A = 32'h0F0F_0F0F;
        B = 32'hF0F0_F0F0;
        #1;

        check_outputs(1'b0, 32'hFFFF_FFFF);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_32bit Testbench");
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
        input expected_C32;
        input [31:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_C32 === (expected_C32 ^ C32 ^ expected_C32) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: C32=%b, S=%h",
                         C32, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: C32=%b, S=%h",
                         expected_C32, expected_S);
                $display("  Got:      C32=%b, S=%h",
                         C32, S);
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
