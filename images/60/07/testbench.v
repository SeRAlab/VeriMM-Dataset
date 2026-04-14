`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [10:0] b;
    reg [15:0] c;
    reg [1:0] sel;
    wire [15:0] res;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .sel(sel),
        .res(res)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0 (res=a+b), small positive numbers", test_num);
            a = 8'sd10;
            b = 11'sd20;
            c = 16'sd0;
            sel = 2'd0;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0 (res=a+b), negative numbers", test_num);
            a = -8'sd5;
            b = -11'sd15;
            c = 16'sd0;
            sel = 2'd0;
            #1;

            check_outputs(-16'sd20);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1 (res=a-b), simple subtraction", test_num);
            a = 8'sd50;
            b = 11'sd20;
            c = 16'sd0;
            sel = 2'd1;
            #1;

            check_outputs(16'sd30);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1 (res=a-b), resulting in negative", test_num);
            a = 8'sd20;
            b = 11'sd50;
            c = 16'sd0;
            sel = 2'd1;
            #1;

            check_outputs(-16'sd30);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=2 (res=a+c), mixing 8-bit and 16-bit", test_num);
            a = 8'sd120;
            b = 11'sd0;
            c = 16'sd1000;
            sel = 2'd2;
            #1;

            check_outputs(16'sd1120);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=2 (res=a+c), negative values", test_num);
            a = -8'sd100;
            b = 11'sd0;
            c = -16'sd500;
            sel = 2'd2;
            #1;

            check_outputs(-16'sd600);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=0 (res=a+b), maximum boundary values", test_num);
            a = 8'sd127;
            b = 11'sd1023;
            c = 16'sd0;
            sel = 2'd0;
            #1;

            check_outputs(16'sd1150);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1 (res=a-b), minimum/maximum boundary", test_num);
            a = -8'sd128;
            b = 11'sd1023;
            c = 16'sd0;
            sel = 2'd1;
            #1;

            check_outputs(-16'sd1151);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=2 (res=a+c), checking signed overflow wrap-around", test_num);
            a = 8'sd10;
            c = 16'sd32760;
            sel = 2'd2;



            #1;




            check_outputs(-16'sd32766);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: sel=1 (res=a-b), subtract negative (addition)", test_num);
            a = -8'sd10;
            b = -11'sd100;
            c = 16'sd0;
            sel = 2'd1;
            #1;

            check_outputs(16'sd90);
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
        input [15:0] expected_res;
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
