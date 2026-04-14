`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire [7:0] z;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .z(z)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: sel=0 (AND), a=8'h00, b=8'h00", test_num);
            a = 8'h00;
            b = 8'h00;
            sel = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: sel=0 (AND), a=8'hFF, b=8'hFF", test_num);
            a = 8'hFF;
            b = 8'hFF;
            sel = 0;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: sel=0 (AND), a=8'hAA, b=8'h55", test_num);
            a = 8'hAA;
            b = 8'h55;
            sel = 0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: sel=0 (AND), a=8'hF0, b=8'hCC", test_num);
            a = 8'hF0;
            b = 8'hCC;
            sel = 0;
            #1;

            check_outputs(8'hC0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: sel=0 (AND), a=8'h12, b=8'h34", test_num);
            a = 8'h12;
            b = 8'h34;
            sel = 0;
            #1;

            check_outputs(8'h10);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: sel=1 (OR), a=8'h00, b=8'h00", test_num);
            a = 8'h00;
            b = 8'h00;
            sel = 1;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: sel=1 (OR), a=8'hFF, b=8'h00", test_num);
            a = 8'hFF;
            b = 8'h00;
            sel = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: sel=1 (OR), a=8'hAA, b=8'h55", test_num);
            a = 8'hAA;
            b = 8'h55;
            sel = 1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: sel=1 (OR), a=8'hF0, b=8'hCC", test_num);
            a = 8'hF0;
            b = 8'hCC;
            sel = 1;
            #1;

            check_outputs(8'hFC);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: sel=1 (OR), a=8'h12, b=8'h34", test_num);
            a = 8'h12;
            b = 8'h34;
            sel = 1;
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
