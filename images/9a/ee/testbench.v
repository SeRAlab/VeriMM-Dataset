`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] a;
    reg [15:0] b;
    reg [15:0] c;
    reg [15:0] d;
    reg sel;
    wire [47:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .sel(sel),
        .res(res)
    );
    task testcase001;

        begin
            test_num = 1;
            a = 16'h0014;
            b = 16'h000A;
            c = 16'h001E;
            d = 16'h0005;
            sel = 0;


            #1;



            check_outputs(48'h001E000A0023);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            a = 16'h0014;
            b = 16'h000A;
            c = 16'h001E;
            d = 16'h0005;
            sel = 1;


            #1;



            check_outputs(48'h000A001E0019);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            a = 16'hFFFF;
            b = 16'h0001;
            c = 16'h000A;
            d = 16'h000B;
            sel = 0;


            #1;



            check_outputs(48'h0000FFFE0015);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            a = 16'h0005;
            b = 16'h000A;
            c = 16'h0001;
            d = 16'h0001;
            sel = 1;


            #1;



            check_outputs(48'hFFFB000F0000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            a = 16'h1234;
            b = 16'h4321;
            c = 16'hABCD;
            d = 16'h1234;
            sel = 0;



            #1;




            check_outputs(48'h5555CF13BE01);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            a = 16'h0000;
            b = 16'h0000;
            c = 16'h0000;
            d = 16'h0000;
            sel = 1;
            #1;

            check_outputs(48'h000000000000);
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
        input [47:0] expected_res;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_res === (expected_res ^ res ^ expected_res)) begin
                $display("PASS");
                $display("  Outputs: res=%h",
                         res);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: res=%h",
                         expected_res);
                $display("  Got:      res=%h",
                         res);
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
