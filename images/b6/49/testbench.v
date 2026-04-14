`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg OrigULA;
    reg [31:0] entrada1;
    reg [31:0] entrada2;
    wire [31:0] saida;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .OrigULA(OrigULA),
        .entrada1(entrada1),
        .entrada2(entrada2),
        .saida(saida)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select entrada1 (OrigULA = 0)", test_num);
            OrigULA = 1'b0;
            entrada1 = 32'hDEADBEEF;
            entrada2 = 32'hCAFEBABE;
            #10;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Select entrada2 (OrigULA = 1)", test_num);
            OrigULA = 1'b1;
            entrada1 = 32'hDEADBEEF;
            entrada2 = 32'hCAFEBABE;
            #10;
            #1;

            check_outputs(32'hCAFEBABE);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All zeros on input 1, Select OrigULA = 0", test_num);
            OrigULA = 1'b0;
            entrada1 = 32'h00000000;
            entrada2 = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: All ones on input 2, Select OrigULA = 1", test_num);
            OrigULA = 1'b1;
            entrada1 = 32'h00000000;
            entrada2 = 32'hFFFFFFFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits pattern (0x55555555)", test_num);
            OrigULA = 1'b0;
            entrada1 = 32'h55555555;
            entrada2 = 32'hAAAAAAAA;
            #10;
            #1;

            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Alternating bits pattern (0xAAAAAAAA)", test_num);
            OrigULA = 1'b1;
            entrada1 = 32'h55555555;
            entrada2 = 32'hAAAAAAAA;
            #10;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern selection 1", test_num);
            OrigULA = 1'b0;
            entrada1 = 32'h12345678;
            entrada2 = 32'h87654321;
            #10;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Random pattern selection 2", test_num);
            OrigULA = 1'b1;
            entrada1 = 32'h12345678;
            entrada2 = 32'h87654321;
            #10;
            #1;

            check_outputs(32'h87654321);
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
        input [31:0] expected_saida;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_saida === (expected_saida ^ saida ^ expected_saida)) begin
                $display("PASS");
                $display("  Outputs: saida=%h",
                         saida);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: saida=%h",
                         expected_saida);
                $display("  Got:      saida=%h",
                         saida);
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
