`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] data0_i;
    reg [31:0] data1_i;
    wire zero_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data0_i(data0_i),
        .data1_i(data1_i),
        .zero_o(zero_o)
    );
    task testcase001;

        begin
            test_num = 1;
            data0_i = 32'h0000_0000;
            data1_i = 32'h0000_0000;
            $display("Test Case %0d: Both inputs zero", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            data0_i = 32'hFFFF_FFFF;
            data1_i = 32'hFFFF_FFFF;
            $display("Test Case %0d: Both inputs all ones", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            data0_i = 32'hA5A5_A5A5;
            data1_i = 32'hA5A5_A5A5;
            $display("Test Case %0d: Both inputs same random pattern", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            data0_i = 32'h0000_0000;
            data1_i = 32'h0000_0001;
            $display("Test Case %0d: Difference in LSB", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            data0_i = 32'h8000_0000;
            data1_i = 32'h0000_0000;
            $display("Test Case %0d: Difference in MSB", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            data0_i = 32'h1234_5678;
            data1_i = 32'h1234_5679;
            $display("Test Case %0d: Very similar values", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            data0_i = 32'hAAAA_AAAA;
            data1_i = 32'h5555_5555;
            $display("Test Case %0d: Bitwise inverse values", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            data0_i = 32'hFFFF_FFFF;
            data1_i = 32'h0000_0000;
            $display("Test Case %0d: All ones vs All zeros", test_num);
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            data0_i = 32'h0000_FFFF;
            data1_i = 32'h0000_FFFF;
            $display("Test Case %0d: Lower 16 bits equal", test_num);
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            data0_i = 32'hDEAD_BEEF;
            data1_i = 32'hDEAD_BEEF;
            $display("Test Case %0d: Specific Hex Pattern equal", test_num);
            #1;

            check_outputs(1'b1);
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
        input expected_zero_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_zero_o === (expected_zero_o ^ zero_o ^ expected_zero_o)) begin
                $display("PASS");
                $display("  Outputs: zero_o=%b",
                         zero_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: zero_o=%b",
                         expected_zero_o);
                $display("  Got:      zero_o=%b",
                         zero_o);
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
