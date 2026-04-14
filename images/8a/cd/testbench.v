`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] E_i;
    reg [31:0] F_i;
    reg [31:0] G_i;
    wire [31:0] ch_o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .E_i(E_i),
        .F_i(F_i),
        .G_i(G_i),
        .ch_o(ch_o)
    );
    task testcase001;

        begin
            test_num = 1;
            E_i = 32'h00000000;
            F_i = 32'h00000000;
            G_i = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            E_i = 32'hFFFFFFFF;
            F_i = 32'h12345678;
            G_i = 32'h9ABCDEF0;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            E_i = 32'h00000000;
            F_i = 32'h12345678;
            G_i = 32'h9ABCDEF0;
            #1;

            check_outputs(32'h9ABCDEF0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            E_i = 32'hAAAAAAAA;
            F_i = 32'hFFFFFFFF;
            G_i = 32'h00000000;

            #1;


            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            E_i = 32'h55555555;
            F_i = 32'hFFFFFFFF;
            G_i = 32'h00000000;

            #1;


            check_outputs(32'h55555555);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            E_i = 32'hF0F0F0F0;
            F_i = 32'hCCCCCCCC;
            G_i = 32'h33333333;



            #1;




            check_outputs(32'hC3C3C3C3);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            E_i = 32'h0F0F0F0F;
            F_i = 32'hA5A5A5A5;
            G_i = 32'h5A5A5A5A;



            #1;




            check_outputs(32'h55555555);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            E_i = 32'h87654321;
            F_i = 32'hFEDCBA98;
            G_i = 32'h11223344;



            #1;




            check_outputs(32'h94463244);
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
        input [31:0] expected_ch_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ch_o === (expected_ch_o ^ ch_o ^ expected_ch_o)) begin
                $display("PASS");
                $display("  Outputs: ch_o=%h",
                         ch_o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ch_o=%h",
                         expected_ch_o);
                $display("  Got:      ch_o=%h",
                         ch_o);
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
