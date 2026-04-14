`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] ALU_F;
    reg OF;
    reg [2:0] SW;
    reg ZF;
    wire [7:0] LED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ALU_F(ALU_F),
        .OF(OF),
        .SW(SW),
        .ZF(ZF),
        .LED(LED)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALU_F [7:0]", test_num);
            ALU_F = 32'hA1B2C3D4;
            OF = 1'b0;
            ZF = 1'b0;
            SW = 3'b000;
            #1;

            check_outputs(8'hD4);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALU_F [15:8]", test_num);
            ALU_F = 32'hA1B2C3D4;
            OF = 1'b0;
            ZF = 1'b0;
            SW = 3'b001;
            #1;

            check_outputs(8'hC3);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALU_F [23:16]", test_num);
            ALU_F = 32'hA1B2C3D4;
            OF = 1'b0;
            ZF = 1'b0;
            SW = 3'b010;
            #1;

            check_outputs(8'hB2);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: ALU_F [31:24]", test_num);
            ALU_F = 32'hA1B2C3D4;
            OF = 1'b0;
            ZF = 1'b0;
            SW = 3'b011;
            #1;

            check_outputs(8'hA1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Flags (OF=0, ZF=0)", test_num);
            ALU_F = 32'hFFFFFFFF;
            OF = 1'b0;
            ZF = 1'b0;
            SW = 3'b100;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Flags (OF=0, ZF=1)", test_num);
            ALU_F = 32'h0;
            OF = 1'b0;
            ZF = 1'b1;
            SW = 3'b100;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Flags (OF=1, ZF=0)", test_num);
            ALU_F = 32'h0;
            OF = 1'b1;
            ZF = 1'b0;
            SW = 3'b100;
            #1;

            check_outputs(8'h02);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Flags (OF=1, ZF=1)", test_num);
            ALU_F = 32'h0;
            OF = 1'b1;
            ZF = 1'b1;
            SW = 3'b100;
            #1;

            check_outputs(8'h03);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Default case (SW=7)", test_num);
            ALU_F = 32'hFFFFFFFF;
            OF = 1'b1;
            ZF = 1'b1;
            SW = 3'b111;
            #1;

            check_outputs(8'h00);
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
        input [7:0] expected_LED;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED === (expected_LED ^ LED ^ expected_LED)) begin
                $display("PASS");
                $display("  Outputs: LED=%h",
                         LED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED=%h",
                         expected_LED);
                $display("  Got:      LED=%h",
                         LED);
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
