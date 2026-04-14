`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] p;
    reg [7:0] q;
    wire [7:0] s;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .p(p),
        .q(q),
        .s(s)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            p = 8'h00;
            q = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            p = 8'hFF;
            q = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (No Overlap)", test_num);
            p = 8'hAA;
            q = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Complementary Nibbles", test_num);
            p = 8'hF0;
            q = 8'h0F;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overlap (Low Nibble)", test_num);
            p = 8'h0F;
            q = 8'h03;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Partial Overlap (High Nibble)", test_num);
            p = 8'hF0;
            q = 8'hA0;
            #1;

            check_outputs(8'h5F);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Set (LSB)", test_num);
            p = 8'h01;
            q = 8'h01;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit Set (MSB)", test_num);
            p = 8'h80;
            q = 8'h80;
            #1;

            check_outputs(8'h7F);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Identity with p=FF", test_num);
            p = 8'hFF;
            q = 8'hC3;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Random Pattern", test_num);
            p = 8'hB6;
            q = 8'hDA;


            #1;



            check_outputs(8'h6D);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("top_module Testbench");
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
        input [7:0] expected_s;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_s === (expected_s ^ s ^ expected_s)) begin
                $display("PASS");
                $display("  Outputs: s=%h",
                         s);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: s=%h",
                         expected_s);
                $display("  Got:      s=%h",
                         s);
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
