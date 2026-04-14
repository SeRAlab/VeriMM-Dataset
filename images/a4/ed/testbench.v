`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] data;
    wire [16:0] parity_data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .data(data),
        .parity_data(parity_data)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Zeros", test_num);
            data = 16'h0000;

            #1;


            check_outputs(17'h0_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All Ones", test_num);
            data = 16'hFFFF;

            #1;


            check_outputs(17'h0_FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (LSB)", test_num);
            data = 16'h0001;

            #1;


            check_outputs(17'h1_0001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Single Bit (MSB)", test_num);
            data = 16'h8000;

            #1;


            check_outputs(17'h1_8000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (0101...)", test_num);
            data = 16'h5555;

            #1;


            check_outputs(17'h0_5555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating Bits (1010...)", test_num);
            data = 16'hAAAA;

            #1;


            check_outputs(17'h0_AAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern 1234", test_num);
            data = 16'h1234;


            #1;



            check_outputs(17'h1_1234);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern BEEF", test_num);
            data = 16'hBEEF;


            #1;



            check_outputs(17'h1_BEEF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern CAFE", test_num);
            data = 16'hCAFE;


            #1;



            check_outputs(17'h1_CAFE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Pattern F00F", test_num);
            data = 16'hF00F;


            #1;



            check_outputs(17'h0_F00F);
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
        input [16:0] expected_parity_data;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_parity_data === (expected_parity_data ^ parity_data ^ expected_parity_data)) begin
                $display("PASS");
                $display("  Outputs: parity_data=%h",
                         parity_data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: parity_data=%h",
                         expected_parity_data);
                $display("  Got:      parity_data=%h",
                         parity_data);
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
