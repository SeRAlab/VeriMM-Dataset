`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [33:0] a34;
    reg [33:0] a34_n;
    reg [33:0] a34x2;
    reg [33:0] a34x2_n;
    reg [2:0] sel;
    wire [33:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a34(a34),
        .a34_n(a34_n),
        .a34x2(a34x2),
        .a34x2_n(a34x2_n),
        .sel(sel),
        .dout(dout)
    );
    task set_inputs;

        begin
            a34     = 34'h2AAAAAAAA;
            a34_n   = 34'h155555555;
            a34x2   = 34'h0CCCCCCCC;
            a34x2_n = 34'h333333333;
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            set_inputs();
            sel = 3'b000;
            #1;

            check_outputs(34'h0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            set_inputs();
            sel = 3'b001;
            #1;

            check_outputs(a34);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            set_inputs();
            sel = 3'b010;
            #1;

            check_outputs(a34);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            set_inputs();
            sel = 3'b011;
            #1;

            check_outputs(a34x2);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            set_inputs();
            sel = 3'b100;
            #1;

            check_outputs(a34x2_n);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            set_inputs();
            sel = 3'b101;
            #1;

            check_outputs(a34_n);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            set_inputs();
            sel = 3'b110;
            #1;

            check_outputs(a34_n);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            set_inputs();
            sel = 3'b111;
            #1;

            check_outputs(34'h0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            a34     = 34'h3FFFFFFFF;
            a34_n   = 34'h000000000;
            a34x2   = 34'h123456789;
            a34x2_n = 34'h29ABCDEFF;
            sel = 3'b011;
            #1;

            check_outputs(34'h123456789);
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
        input [33:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
