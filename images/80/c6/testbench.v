`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in_e;
    reg [47:0] in_m;
    wire [7:0] out_e;
    wire [47:0] out_m;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in_e(in_e),
        .in_m(in_m),
        .out_e(out_e),
        .out_m(out_m)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: No shift required (Bit 47 is 0)", test_num);
            in_e = 8'h64;
            in_m = 48'h4000_0000_0000;
            #1;

            check_outputs(8'h64, 48'h4000_0000_0000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Right shift required (Bit 47 is 1)", test_num);
            in_e = 8'h64;
            in_m = 48'h8000_0000_0000;

            #1;


            check_outputs(8'h63, 48'h4000_0000_0000);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Shift required with lower bit data", test_num);
            in_e = 8'h10;
            in_m = 48'hC000_0000_0001;

            #1;


            check_outputs(8'h0F, 48'h6000_0000_0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All zeros input", test_num);
            in_e = 8'h00;
            in_m = 48'h0000_0000_0000;
            #1;

            check_outputs(8'h00, 48'h0000_0000_0000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Max mantissa value", test_num);
            in_e = 8'hFF;
            in_m = 48'hFFFF_FFFF_FFFF;

            #1;


            check_outputs(8'hFE, 48'h7FFF_FFFF_FFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Bit 47 is 0, Bit 46 is 1 (No shift)", test_num);
            in_e = 8'h80;
            in_m = 48'h7FFF_FFFF_FFFF;
            #1;

            check_outputs(8'h80, 48'h7FFF_FFFF_FFFF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Min exponent with shift (Check underflow)", test_num);
            in_e = 8'h01;
            in_m = 48'hA000_0000_0000;
            #1;

            check_outputs(8'h00, 48'h5000_0000_0000);
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
        input [7:0] expected_out_e;
        input [47:0] expected_out_m;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_e === (expected_out_e ^ out_e ^ expected_out_e) &&
                expected_out_m === (expected_out_m ^ out_m ^ expected_out_m)) begin
                $display("PASS");
                $display("  Outputs: out_e=%h, out_m=%h",
                         out_e, out_m);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_e=%h, out_m=%h",
                         expected_out_e, expected_out_m);
                $display("  Got:      out_e=%h, out_m=%h",
                         out_e, out_m);
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
