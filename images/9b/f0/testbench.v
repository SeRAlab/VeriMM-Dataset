`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ctrl;
    reg [7:0] u;
    reg [7:0] v;
    reg [7:0] w;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl(ctrl),
        .u(u),
        .v(v),
        .w(w),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: ctrl=0, v=55, w=AA, u=FF (XOR and AND)", test_num);
            ctrl = 0;
            v = 8'h55;
            w = 8'hAA;
            u = 8'hFF;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: ctrl=0, v=33, w=33, u=FF (XOR result 0)", test_num);
            ctrl = 0;
            v = 8'h33;
            w = 8'h33;
            u = 8'hFF;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: ctrl=0, v=F0, w=0F, u=AA (Masking result)", test_num);
            ctrl = 0;
            v = 8'hF0;
            w = 8'h0F;
            u = 8'hAA;

            #1;


            check_outputs(8'hAA);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: ctrl=1, v=F0, w=0F, u=55 (AND result 0, OR with u)", test_num);
            ctrl = 1;
            v = 8'hF0;
            w = 8'h0F;
            u = 8'h55;

            #1;


            check_outputs(8'h55);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: ctrl=1, v=FF, w=FF, u=00 (AND result FF)", test_num);
            ctrl = 1;
            v = 8'hFF;
            w = 8'hFF;
            u = 8'h00;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: ctrl=1, v=AA, w=AA, u=55 (AND result AA, OR result FF)", test_num);
            ctrl = 1;
            v = 8'hAA;
            w = 8'hAA;
            u = 8'h55;

            #1;


            check_outputs(8'hFF);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: All zeros check", test_num);
            ctrl = 0; v = 8'h00; w = 8'h00; u = 8'h00;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Toggle ctrl with same inputs", test_num);
            v = 8'hFF; w = 8'h00; u = 8'hCC;
            ctrl = 0;
            #1;

            check_outputs(8'hCC);

            test_num = 9;
            ctrl = 1;
            #1;

            check_outputs(8'hCC);
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
        input [7:0] expected_z;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_z === (expected_z ^ z ^ expected_z)) begin
                $display("PASS");
                $display("  Outputs: z=%h",
                         z);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: z=%h",
                         expected_z);
                $display("  Got:      z=%h",
                         z);
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
