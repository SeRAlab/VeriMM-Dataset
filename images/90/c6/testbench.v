`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg sel;
    wire [7:0] y;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .sel(sel),
        .y(y)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=0 (NAND), a=00, b=00", test_num);
            sel = 1'b0; a = 8'h00; b = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=0 (NAND), a=FF, b=FF", test_num);
            sel = 1'b0; a = 8'hFF; b = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=0 (NAND), a=AA, b=55", test_num);
            sel = 1'b0; a = 8'hAA; b = 8'h55;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=0 (NAND), a=F0, b=CC", test_num);
            sel = 1'b0; a = 8'hF0; b = 8'hCC;
            #1;

            check_outputs(8'h3F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=1 (NOR), a=00, b=00", test_num);
            sel = 1'b1; a = 8'h00; b = 8'h00;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=1 (NOR), a=FF, b=FF", test_num);
            sel = 1'b1; a = 8'hFF; b = 8'hFF;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=1 (NOR), a=AA, b=55", test_num);
            sel = 1'b1; a = 8'hAA; b = 8'h55;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=1 (NOR), a=F0, b=0F", test_num);
            sel = 1'b1; a = 8'hF0; b = 8'h0F;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=1 (NOR), a=12, b=34", test_num);
            sel = 1'b1; a = 8'h12; b = 8'h34;
            #1;

            check_outputs(8'hC9);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: sel=0 (NAND), a=12, b=34", test_num);
            sel = 1'b0; a = 8'h12; b = 8'h34;
            #1;

            check_outputs(8'hEF);
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
        input [7:0] expected_y;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_y === (expected_y ^ y ^ expected_y)) begin
                $display("PASS");
                $display("  Outputs: y=%h",
                         y);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: y=%h",
                         expected_y);
                $display("  Got:      y=%h",
                         y);
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
