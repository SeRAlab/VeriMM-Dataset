`timescale 1ns/1ps

module adder_64bit_tb;

    // Testbench signals (combinational circuit)
    reg [63:0] a;
    reg [63:0] b;
    wire [63:0] sum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    adder_64bit dut (
        .a(a),
        .b(b),
        .sum(sum)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Zero addition", test_num);
            a = 64'h0;
            b = 64'h0;
            #1;

            check_outputs(64'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Small positive addition", test_num);
            a = 64'h0000_0000_0000_0005;
            b = 64'h0000_0000_0000_000A;
            #1;

            check_outputs(64'h0000_0000_0000_000F);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Max value plus zero", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0000;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Internal 16-bit carry propagation", test_num);

            a = 64'h0000_0000_0000_FFFF;
            b = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'h0000_0000_0001_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Full carry propagation across all blocks", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFE;
            b = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Overflow/Wrapping condition", test_num);
            a = 64'hFFFF_FFFF_FFFF_FFFF;
            b = 64'h0000_0000_0000_0001;
            #1;

            check_outputs(64'h0000_0000_0000_0000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bit pattern", test_num);
            a = 64'hAAAA_AAAA_AAAA_AAAA;
            b = 64'h5555_5555_5555_5555;
            #1;

            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Carry into middle blocks", test_num);
            a = 64'h0000_FFFF_0000_0000;
            b = 64'h0000_0001_0000_0000;
            #1;

            check_outputs(64'h0001_0000_0000_0000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complex addition", test_num);
            a = 64'h1234_5678_9ABC_DEF0;
            b = 64'hFEDC_BA98_7654_3210;

            #1;


            check_outputs(64'hFFFF_FFFF_FFFF_FFFF);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random-like value addition", test_num);
            a = 64'hDEAD_BEEF_CAFE_BABE;
            b = 64'h1111_1111_1111_1111;
            #1;

            check_outputs(64'hEFAF_CFFF_DBFF_CBCF);
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
        input [63:0] expected_sum;
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
