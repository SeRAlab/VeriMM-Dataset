`timescale 1ns/1ps

module multiplier_16bit_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] A;
    reg [15:0] B;
    wire [31:0] P;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    multiplier_16bit dut (
        .A(A),
        .B(B),
        .P(P)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Zero (0 * 0)", test_num);
        A = 16'h0000; B = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication with one operand as Zero (FFFF * 0)", test_num);
        A = 16'hFFFF; B = 16'h0000;
        #1;

        check_outputs(32'h00000000);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Multiplication by Identity (1234 * 1)", test_num);
        A = 16'h1234; B = 16'h0001;
        #1;

        check_outputs(32'h00001234);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Maximum values (FFFF * FFFF)", test_num);
        A = 16'hFFFF; B = 16'hFFFF;

        #1;


        check_outputs(32'hFFFE0001);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Powers of 2 (0100 * 0080)", test_num);
        A = 16'h0100;
        B = 16'h0080;
        #1;

        check_outputs(32'h00008000);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Large unsigned numbers (ABCD * 1234)", test_num);
        A = 16'hABCD;
        B = 16'h1234;
        #1;

        check_outputs(32'h0C351E24);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Patterned bits (AAAA * 5555)", test_num);
        A = 16'hAAAA;
        B = 16'h5555;
        #1;

        check_outputs(32'h38E31C72);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Test %0d: Small values (000F * 000B)", test_num);
        A = 16'h000F;
        B = 16'h000B;
        #1;

        check_outputs(32'h000000A5);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("multiplier_16bit Testbench");
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
        input [31:0] expected_P;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_P === (expected_P ^ P ^ expected_P)) begin
                $display("PASS");
                $display("  Outputs: P=%h",
                         P);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: P=%h",
                         expected_P);
                $display("  Got:      P=%h",
                         P);
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
