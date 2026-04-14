`timescale 1ns/1ps

module and32bit_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] a;
    reg [31:0] b;
    wire [31:0] result;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    and32bit dut (
        .a(a),
        .b(b),
        .result(result)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            a = 32'h0000_0000;
            b = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            a = 32'hFFFF_FFFF;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hFFFF_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity Property (A & 1s = A)", test_num);
            a = 32'hA5A5_5A5A;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(32'hA5A5_5A5A);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero Property (A & 0s = 0)", test_num);
            a = 32'h1234_5678;
            b = 32'h0000_0000;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Complementary Bits", test_num);
            a = 32'hAAAA_AAAA;
            b = 32'h5555_5555;
            #1;

            check_outputs(32'h0000_0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Specific Bit Patterns", test_num);
            a = 32'hF0F0_CCCC;
            b = 32'hFFFF_0000;
            #1;

            check_outputs(32'hF0F0_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Test (MSB and LSB)", test_num);
            a = 32'h8000_0001;
            b = 32'h8000_0001;
            #1;

            check_outputs(32'h8000_0001);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern", test_num);
            a = 32'h1357_9BDF;
            b = 32'h2468_ACE0;
            #1;

            check_outputs(32'h1357_9BDF & 32'h2468_ACE0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("and32bit Testbench");
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
        input [31:0] expected_result;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_result === (expected_result ^ result ^ expected_result)) begin
                $display("PASS");
                $display("  Outputs: result=%h",
                         result);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: result=%h",
                         expected_result);
                $display("  Got:      result=%h",
                         result);
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
