`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] Ecm;
    reg [7:0] Fmc;
    reg [7:0] Hcm;
    reg [7:0] Hmc;
    reg [7:0] Hmm;
    reg [1:0] select_ms;
    wire [7:0] Ecc;
    wire [7:0] Fcc;
    wire [7:0] Hcc;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Ecm(Ecm),
        .Fmc(Fmc),
        .Hcm(Hcm),
        .Hmc(Hmc),
        .Hmm(Hmm),
        .select_ms(select_ms),
        .Ecc(Ecc),
        .Fcc(Fcc),
        .Hcc(Hcc)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Match condition, Hmm dominant", test_num);
            select_ms = 2'b00;
            Hmm = 8'd100;
            Hmc = 8'd50;
            Hcm = 8'd50;
            Ecm = 8'd40;
            Fmc = 8'd40;




            #1;





            check_outputs(8'd49, 8'd49, 8'd102);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mismatch condition, Ecc dominant", test_num);
            select_ms = 2'b01;
            Hmm = 8'd20;
            Hmc = 8'd50;
            Hcm = 8'd10;
            Ecm = 8'd45;
            Fmc = 8'd10;




            #1;





            check_outputs(8'd49, 8'd9, 8'd49);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Mismatch condition, Fcc dominant", test_num);
            select_ms = 2'b10;
            Hmm = 8'd30;
            Hmc = 8'd10;
            Hcm = 8'd60;
            Ecm = 8'd10;
            Fmc = 8'd55;




            #1;





            check_outputs(8'd9, 8'd59, 8'd59);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Zero inputs boundary check", test_num);
            select_ms = 2'b00;
            Hmm = 8'd0;
            Hmc = 8'd0;
            Hcm = 8'd0;
            Ecm = 8'd0;
            Fmc = 8'd0;




            #1;





            check_outputs(8'd0, 8'd0, 8'd2);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Running Testcase %0d: Maximum saturation check", test_num);
            select_ms = 2'b00;
            Hmm = 8'd255;
            Hmc = 8'd255;
            Hcm = 8'd255;
            Ecm = 8'd255;
            Fmc = 8'd255;




            #1;





            check_outputs(8'd254, 8'd254, 8'd255);
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
        input [7:0] expected_Ecc;
        input [7:0] expected_Fcc;
        input [7:0] expected_Hcc;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Ecc === (expected_Ecc ^ Ecc ^ expected_Ecc) &&
                expected_Fcc === (expected_Fcc ^ Fcc ^ expected_Fcc) &&
                expected_Hcc === (expected_Hcc ^ Hcc ^ expected_Hcc)) begin
                $display("PASS");
                $display("  Outputs: Ecc=%h, Fcc=%h, Hcc=%h",
                         Ecc, Fcc, Hcc);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Ecc=%h, Fcc=%h, Hcc=%h",
                         expected_Ecc, expected_Fcc, expected_Hcc);
                $display("  Got:      Ecc=%h, Fcc=%h, Hcc=%h",
                         Ecc, Fcc, Hcc);
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
