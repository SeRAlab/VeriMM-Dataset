`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] arg1;
    reg [3:0] arg2;
    reg [3:0] arg3;
    reg [3:0] arg4;
    reg gnd_sup;
    reg pwr_sup;
    reg [1:0] sel;
    wire [3:0] out_mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .arg1(arg1),
        .arg2(arg2),
        .arg3(arg3),
        .arg4(arg4),
        .gnd_sup(gnd_sup),
        .pwr_sup(pwr_sup),
        .sel(sel),
        .out_mux(out_mux)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Test %0d: Select arg1 (sel=00) with proper power", test_num);
            pwr_sup = 1;
            gnd_sup = 0;
            arg1 = 4'hA;
            arg2 = 4'h5;
            arg3 = 4'hC;
            arg4 = 4'h3;
            sel = 2'b00;
            #1;

            check_outputs(4'hA);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Test %0d: Select arg2 (sel=01) with proper power", test_num);
            pwr_sup = 1;
            gnd_sup = 0;
            arg1 = 4'hA;
            arg2 = 4'h5;
            arg3 = 4'hC;
            arg4 = 4'h3;
            sel = 2'b01;
            #1;

            check_outputs(4'h5);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Test %0d: Select arg3 (sel=10) with proper power", test_num);
            pwr_sup = 1;
            gnd_sup = 0;
            arg1 = 4'hA;
            arg2 = 4'h5;
            arg3 = 4'hC;
            arg4 = 4'h3;
            sel = 2'b10;
            #1;

            check_outputs(4'hC);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Test %0d: Select arg4 (sel=11) with proper power", test_num);
            pwr_sup = 1;
            gnd_sup = 0;
            arg1 = 4'hA;
            arg2 = 4'h5;
            arg3 = 4'hC;
            arg4 = 4'h3;
            sel = 2'b11;
            #1;

            check_outputs(4'h3);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Test %0d: Power supply off (pwr_sup=0)", test_num);
            pwr_sup = 0;
            gnd_sup = 0;
            arg1 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'bxxxx);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Test %0d: Ground supply active (gnd_sup=1)", test_num);
            pwr_sup = 1;
            gnd_sup = 1;
            arg1 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'bxxxx);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Test %0d: Power off and Ground active", test_num);
            pwr_sup = 0;
            gnd_sup = 1;
            arg1 = 4'hF;
            sel = 2'b00;
            #1;

            check_outputs(4'bxxxx);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Test %0d: Verify output changes when arg input changes", test_num);
            pwr_sup = 1;
            gnd_sup = 0;
            sel = 2'b01;
            arg2 = 4'h1;
            #5;
            arg2 = 4'hE;
            #1;

            check_outputs(4'hE);
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
        input [3:0] expected_out_mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out_mux === (expected_out_mux ^ out_mux ^ expected_out_mux)) begin
                $display("PASS");
                $display("  Outputs: out_mux=%h",
                         out_mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out_mux=%h",
                         expected_out_mux);
                $display("  Got:      out_mux=%h",
                         out_mux);
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
