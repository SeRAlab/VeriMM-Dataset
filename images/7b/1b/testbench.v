`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [2:0] funct3;
    reg [31:0] val_i;
    wire [31:0] val_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .funct3(funct3),
        .val_i(val_i),
        .val_o(val_o)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign-extend 8-bit (Positive)", test_num);
            funct3 = 3'b000;
            val_i = 32'hAAAAAA7F;
            #1;

            check_outputs(32'h0000007F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign-extend 8-bit (Negative)", test_num);
            funct3 = 3'b000;
            val_i = 32'h00000080;
            #1;

            check_outputs(32'hFFFFFF80);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign-extend 16-bit (Positive)", test_num);
            funct3 = 3'b001;
            val_i = 32'hBBBB7FFF;
            #1;

            check_outputs(32'h00007FFF);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign-extend 16-bit (Negative)", test_num);
            funct3 = 3'b001;
            val_i = 32'h00008000;
            #1;

            check_outputs(32'hFFFF8000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pass-through (Word)", test_num);
            funct3 = 3'b010;
            val_i = 32'hDEADBEEF;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero-extend 8-bit", test_num);
            funct3 = 3'b100;
            val_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h000000FF);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero-extend 16-bit", test_num);
            funct3 = 3'b101;
            val_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'h0000FFFF);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sign-extend 8-bit (Max value bits)", test_num);
            funct3 = 3'b000;
            val_i = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Pass-through (Zero input)", test_num);
            funct3 = 3'b010;
            val_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero-extend 16-bit (Half max)", test_num);
            funct3 = 3'b101;
            val_i = 32'h12345678;
            #1;

            check_outputs(32'h00005678);
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
        input [31:0] expected_val_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_val_o === (expected_val_o ^ val_o ^ expected_val_o)) begin
                $display("PASS");
                $display("  Outputs: val_o=%h",
                         val_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: val_o=%h",
                         expected_val_o);
                $display("  Got:      val_o=%h",
                         val_o);
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
