`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] x;
    wire [7:0] d_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .d_out(d_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x00 (Zero case)", test_num);
            x = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x01 (No overflow, MSB=0)", test_num);
            x = 8'h01;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x7F (Max value with MSB=0)", test_num);
            x = 8'h7F;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x80 (Min value with MSB=1)", test_num);

            x = 8'h80;
            #1;

            check_outputs(8'h1B);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x81 (Overflow with MSB=1)", test_num);

            x = 8'h81;
            #1;

            check_outputs(8'h19);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0xFF (All ones)", test_num);

            x = 8'hFF;
            #1;

            check_outputs(8'hE5);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x57 (Common AES example, MSB=0)", test_num);
            x = 8'h57;
            #1;

            check_outputs(8'hAE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0xAE (AES example, MSB=1)", test_num);

            x = 8'hAE;
            #1;

            check_outputs(8'h47);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0xD4 (AES example, MSB=1)", test_num);

            x = 8'hD4;
            #1;

            check_outputs(8'hB3);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: x = 0x1B (Polynomial constant)", test_num);
            x = 8'h1B;
            #1;

            check_outputs(8'h36);
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
        input [7:0] expected_d_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_d_out === (expected_d_out ^ d_out ^ expected_d_out)) begin
                $display("PASS");
                $display("  Outputs: d_out=%h",
                         d_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: d_out=%h",
                         expected_d_out);
                $display("  Got:      d_out=%h",
                         d_out);
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
