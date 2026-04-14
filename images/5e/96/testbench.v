`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] b;
    wire [4:0] splited;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .b(b),
        .splited(splited)
    );
    task testcase001;

        begin
            test_num = 1;
            b = 32'h0000_0000;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            b = 32'hFFFF_FFFF;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            b = 32'hFFFF_FFE0;
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            b = 32'h0000_001F;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            b = 32'hAAAA_AAAA;
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            b = 32'h5555_5555;
            #1;

            check_outputs(5'h15);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            b = 32'h1234_5678;
            #1;

            check_outputs(5'h18);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            b = 32'hA5A5_A5A5;
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            b = 32'hDEAD_BEEF;
            #1;

            check_outputs(5'h0F);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            b = 32'h0000_0010;
            #1;

            check_outputs(5'h10);
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
        input [4:0] expected_splited;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_splited === (expected_splited ^ splited ^ expected_splited)) begin
                $display("PASS");
                $display("  Outputs: splited=%h",
                         splited);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: splited=%h",
                         expected_splited);
                $display("  Got:      splited=%h",
                         splited);
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
