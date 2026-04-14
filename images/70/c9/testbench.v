`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] x;
    wire ovf;
    wire [31:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .x(x),
        .ovf(ovf),
        .y(y)
    );
    task testcase001;

        begin
            x = 32'h0000_0000;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase002;

        begin
            x = 32'h3F80_0000;
            #1;

            check_outputs(1'b0, 32'h0000_0001);
        end
        endtask

    task testcase003;

        begin
            x = 32'hBF80_0000;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFF);
        end
        endtask

    task testcase004;

        begin
            x = 32'h4070_0000;
            #1;

            check_outputs(1'b0, 32'h0000_0003);
        end
        endtask

    task testcase005;

        begin
            x = 32'hC0B0_0000;
            #1;

            check_outputs(1'b0, 32'hFFFF_FFFB);
        end
        endtask

    task testcase006;

        begin
            x = 32'h3E40_0000;
            #1;

            check_outputs(1'b0, 32'h0000_0000);
        end
        endtask

    task testcase007;

        begin
            x = 32'h4E00_0000;
            #1;

            check_outputs(1'b0, 32'h2000_0000);
        end
        endtask

    task testcase008;

        begin
            x = 32'hCF00_0000;
            #1;

            check_outputs(1'b0, 32'h8000_0000);
        end
        endtask

    task testcase009;

        begin

            x = 32'h4E7F_FFFF;
            #1;

            check_outputs(1'b0, 32'h7FFF_FF80);
        end
        endtask

    task testcase010;

        begin
            x = 32'h4F00_0000;
            #1;

            check_outputs(1'b1, 32'hxxxxxxxx);
        end
        endtask

    task testcase011;

        begin
            x = 32'hCF00_0001;
            #1;

            check_outputs(1'b1, 32'hxxxxxxxx);
        end
        endtask

    task testcase012;

        begin
            x = 32'h7F80_0000;
            #1;

            check_outputs(1'b1, 32'hxxxxxxxx);
            x = 32'h7FC0_0000;
            #1;

            check_outputs(1'b1, 32'hxxxxxxxx);
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
        testcase011();
        testcase012();
        
        
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
        input expected_ovf;
        input [31:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ovf === (expected_ovf ^ ovf ^ expected_ovf) &&
                expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: ovf=%b, y=%h",
                         ovf, y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ovf=%b, y=%h",
                         expected_ovf, expected_y);
                $display("  Got:      ovf=%b, y=%h",
                         ovf, y);
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
