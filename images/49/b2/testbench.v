`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [17:0] dataa;
    reg [17:0] datab;
    reg signa;
    reg signb;
    wire [35:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .signa(signa),
        .signb(signb),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unsigned 0 * 0", test_num);
            dataa = 18'h00000;
            datab = 18'h00000;
            signa = 1'b0;
            signb = 1'b0;
            #1;

            check_outputs(36'h000000000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unsigned 10 * 5", test_num);
            dataa = 18'd10;
            datab = 18'd5;
            signa = 1'b0;
            signb = 1'b0;
            #1;

            check_outputs(36'd50);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Unsigned Max * Max", test_num);
            dataa = 18'h3FFFF;
            datab = 18'h3FFFF;
            signa = 1'b0;
            signb = 1'b0;

            #1;


            check_outputs(36'hFFFE00001);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signed 50 * 20", test_num);
            dataa = 18'd50;
            datab = 18'd20;
            signa = 1'b1;
            signb = 1'b1;
            #1;

            check_outputs(36'd1000);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signed -1 * 100", test_num);
            dataa = 18'h3FFFF;
            datab = 18'd100;
            signa = 1'b1;
            signb = 1'b1;

            #1;


            check_outputs(36'hFFFFFFFF9C);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signed -10 * -20", test_num);
            dataa = 18'h3FFF6;
            datab = 18'h3FFEC;
            signa = 1'b1;
            signb = 1'b1;
            #1;

            check_outputs(36'd200);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed (Signed -1 * Unsigned 2)", test_num);
            dataa = 18'h3FFFF;
            datab = 18'h00002;
            signa = 1'b1;
            signb = 1'b0;

            #1;


            check_outputs(36'hFFFFFFFFE);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Mixed (Unsigned Max * Signed -1)", test_num);
            dataa = 18'h3FFFF;
            datab = 18'h3FFFF;
            signa = 1'b0;
            signb = 1'b1;

            #1;


            check_outputs(36'hFFFFC0001);
        end
        endtask

    task testcase009;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signed MaxPos * MaxNeg", test_num);
            dataa = 18'h1FFFF;
            datab = 18'h20000;
            signa = 1'b1;
            signb = 1'b1;

            #1;


            check_outputs(36'hBFFFF0000);
        end
        endtask

    task testcase010;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Signed MaxNeg * MaxNeg", test_num);
            dataa = 18'h20000;
            datab = 18'h20000;
            signa = 1'b1;
            signb = 1'b1;

            #1;


            check_outputs(36'h400000000);
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
        input [35:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
