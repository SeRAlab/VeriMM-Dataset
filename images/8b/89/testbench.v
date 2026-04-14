`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [31:0] R;
    wire [47:0] Rout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .R(R),
        .Rout(Rout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros", test_num);
            R = 32'h00000000;
            #1;

            check_outputs(48'h000000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones", test_num);
            R = 32'hFFFFFFFF;
            #1;

            check_outputs(48'hFFFFFFFFFFFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits 0101 (0x55555555)", test_num);
            R = 32'h55555555;


            #1;



            check_outputs(48'hAAAAAAAAAAAA);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Alternating Bits 1010 (0xAAAAAAAA)", test_num);
            R = 32'hAAAAAAAA;

            #1;


            check_outputs(48'h555555555555);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Block Pattern (0xF0F0F0F0)", test_num);
            R = 32'hF0F0F0F0;


            #1;



            check_outputs(48'h7A17A17A17A1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Block Pattern (0x0F0F0F0F)", test_num);
            R = 32'h0F0F0F0F;

            #1;


            check_outputs(48'h85E85E85E85E);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Incremental Nibbles (0x12345678)", test_num);
            R = 32'h12345678;




            #1;





            check_outputs(48'h0A41A82AC3F0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Symmetry Check (0x80000001)", test_num);
            R = 32'h80000001;



            #1;




            check_outputs(48'hC00000000003);
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
        input [47:0] expected_Rout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Rout === (expected_Rout ^ Rout ^ expected_Rout)) begin
                $display("PASS");
                $display("  Outputs: Rout=%h",
                         Rout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Rout=%h",
                         expected_Rout);
                $display("  Got:      Rout=%h",
                         Rout);
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
