`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] AA;
    wire [31:0] DOUT;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AA(AA),
        .DOUT(DOUT)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 00 - Bitmask from index 0 to 0", test_num);
            AA = 7'b00_00000;
            #1;

            check_outputs(32'h00000001);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 00 - Bitmask from index 0 to 15", test_num);
            AA = 7'b00_01111;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 00 - Bitmask from index 0 to 31", test_num);
            AA = 7'b00_11111;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 01 - Bitmask from index 0 to 31", test_num);
            AA = 7'b01_00000;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 01 - Bitmask from index 16 to 31", test_num);
            AA = 7'b01_10000;
            #1;

            check_outputs(32'hFFFF0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 01 - Bitmask from index 31 to 31", test_num);
            AA = 7'b01_11111;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 10 - Only bit 5 high", test_num);
            AA = 7'b10_00101;
            #1;

            check_outputs(32'h00000020);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 10 - Only bit 31 high", test_num);
            AA = 7'b10_11111;
            #1;

            check_outputs(32'h80000000);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 11 - All bits high except bit 0", test_num);
            AA = 7'b11_00000;
            #1;

            check_outputs(32'hFFFFFFFE);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Mode 11 - All bits high except bit 15", test_num);
            AA = 7'b11_01111;
            #1;

            check_outputs(32'hFFFF7FFF);
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
        input [31:0] expected_DOUT;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_DOUT === (expected_DOUT ^ DOUT ^ expected_DOUT)) begin
                $display("PASS");
                $display("  Outputs: DOUT=%h",
                         DOUT);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: DOUT=%h",
                         expected_DOUT);
                $display("  Got:      DOUT=%h",
                         DOUT);
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
