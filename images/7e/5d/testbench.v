`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [31:0] opt1;
    reg [31:0] opt2;
    reg sel;
    wire [31:0] muxout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .opt1(opt1),
        .opt2(opt2),
        .sel(sel),
        .muxout(muxout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=1, Sel=1 (Select opt1)", test_num);
            enable = 1;
            sel = 1;
            opt1 = 32'hAAAAAAAA;
            opt2 = 32'h55555555;
            #1;

            check_outputs(32'hAAAAAAAA);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=1, Sel=0 (Select opt2)", test_num);
            enable = 1;
            sel = 0;
            opt1 = 32'h12345678;
            opt2 = 32'h87654321;
            #1;

            check_outputs(32'h87654321);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=0 (Hold mode), change inputs", test_num);
            enable = 0;
            sel = 1;
            opt1 = 32'hFFFFFFFF;
            opt2 = 32'h00000000;

            #1;


            check_outputs(32'h87654321);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Re-enable, Sel=1 (Select opt1)", test_num);
            enable = 1;
            sel = 1;
            opt1 = 32'hDEADBEEF;
            opt2 = 32'hCAFEBABE;
            #1;

            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Enable=0 (Hold mode), change sel to 0", test_num);
            enable = 0;
            sel = 0;
            opt1 = 32'h00001111;
            opt2 = 32'hFFFF2222;

            #1;


            check_outputs(32'hDEADBEEF);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Zeros with Enable=1", test_num);
            enable = 1;
            sel = 0;
            opt1 = 32'hFFFFFFFF;
            opt2 = 32'h00000000;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: All Ones with Enable=1", test_num);
            enable = 1;
            sel = 1;
            opt1 = 32'hFFFFFFFF;
            opt2 = 32'h00000000;
            #1;

            check_outputs(32'hFFFFFFFF);
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
        input [31:0] expected_muxout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_muxout === (expected_muxout ^ muxout ^ expected_muxout)) begin
                $display("PASS");
                $display("  Outputs: muxout=%h",
                         muxout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: muxout=%h",
                         expected_muxout);
                $display("  Got:      muxout=%h",
                         muxout);
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
