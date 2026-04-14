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
            test_num = 1;
            ZF = 1; OF = 1; SW = 3'b000; ALU_F = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            ZF = 0; OF = 1; SW = 3'b000; ALU_F = 32'h00000042;
            #10;
            #1;

            check_outputs(8'hC2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            ZF = 0; OF = 0; SW = 3'b001; ALU_F = 32'h0000000F;
            #10;

            #1;


            check_outputs(8'h70);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            ZF = 0; OF = 1; SW = 3'b010; ALU_F = 32'h00000001;
            #10;

            #1;


            check_outputs(8'h82);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            ZF = 0; OF = 0; SW = 3'b011; ALU_F = 32'h00000004;
            #10;

            #1;


            check_outputs(8'h02);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            ZF = 0; OF = 1; SW = 3'b100; ALU_F = 32'h0000000A;
            #10;

            #1;


            check_outputs(8'h8B);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            ZF = 0; OF = 0; SW = 3'b101; ALU_F = 32'h00000001;
            #10;

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            ZF = 0; OF = 1; SW = 3'b110; ALU_F = 32'h000000FF;
            #10;

            #1;


            check_outputs(8'h8F);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            ZF = 0; OF = 0; SW = 3'b111; ALU_F = 32'h00000001;
            #10;

            #1;


            check_outputs(8'h41);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            ZF = 0; OF = 1; SW = 3'b000; ALU_F = 32'hABCDEF7F;
            #10;

            #1;


            check_outputs(8'hFF);
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
