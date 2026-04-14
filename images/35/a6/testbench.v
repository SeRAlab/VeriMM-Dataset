`timescale 1ns/1ps

module adder_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] A;
    reg [63:0] B;
    wire CO;
    wire [63:0] S;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_64bit dut (
        .A(A),
        .B(B),
        .CO(CO),
        .S(S)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros", test_num);
            A = 64'h0;
            B = 64'h0;
            #1;

            check_outputs(1'b0, 64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Basic addition no carry", test_num);
            A = 64'h1234_5678_9ABC_DEF0;
            B = 64'h0000_0000_0000_000F;
            #1;

            check_outputs(1'b0, 64'h1234_5678_9ABC_DEFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value plus one (Carry Out)", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'h1;
            #1;

            check_outputs(1'b1, 64'h0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value plus max value", test_num);
            A = 64'hFFFF_FFFF_FFFF_FFFF;
            B = 64'hFFFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(1'b1, 64'hFFFF_FFFF_FFFF_FFFE);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits", test_num);
            A = 64'hAAAA_AAAA_AAAA_AAAA;
            B = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(1'b0, 64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Mid-range carry propagation", test_num);
            A = 64'h0000_0000_FFFF_FFFF;
            B = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(1'b0, 64'h0000_0001_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random pattern 1", test_num);
            A = 64'h8000_0000_0000_0000;
            B = 64'h8000_0000_0000_0000;
            #1;

            check_outputs(1'b1, 64'h0000_0000_0000_0000);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Large sum no carry out", test_num);
            A = 64'h7FFF_FFFF_FFFF_FFFF;
            B = 64'h7FFF_FFFF_FFFF_FFFF;
            #1;

            check_outputs(1'b0, 64'hFFFE_FFFF_FFFF_FFFE);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("adder_64bit Testbench");
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
        input expected_CO;
        input [63:0] expected_S;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_CO === (expected_CO ^ CO ^ expected_CO) &&
                expected_S === (expected_S ^ S ^ expected_S)) begin
                $display("PASS");
                $display("  Outputs: CO=%b, S=%h",
                         CO, S);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: CO=%b, S=%h",
                         expected_CO, expected_S);
                $display("  Got:      CO=%b, S=%h",
                         CO, S);
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
