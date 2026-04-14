`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg FAOut;
    reg andOut;
    reg orOut;
    reg [5:0] sel;
    reg sltOut;
    wire dataOut;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .FAOut(FAOut),
        .andOut(andOut),
        .orOut(orOut),
        .sel(sel),
        .sltOut(sltOut),
        .dataOut(dataOut)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: sel[2]=1, sel[0]=1 - Selecting andOut (Expect 1)", test_num);
        sel = 6'b000101;
        andOut = 1'b1;
        orOut  = 1'b0;
        sltOut = 1'b0;
        FAOut  = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: sel[2]=1, sel[0]=1 - Selecting andOut (Expect 0)", test_num);
        sel = 6'b111101;
        andOut = 1'b0;
        orOut  = 1'b1;
        sltOut = 1'b1;
        FAOut  = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: sel[2]=1, sel[0]=0 - Selecting orOut (Expect 1)", test_num);
        sel = 6'b000100;
        andOut = 1'b0;
        orOut  = 1'b1;
        sltOut = 1'b0;
        FAOut  = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: sel[2]=1, sel[0]=0 - Selecting orOut (Expect 0)", test_num);
        sel = 6'b010110;
        andOut = 1'b1;
        orOut  = 1'b0;
        sltOut = 1'b1;
        FAOut  = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: sel[2]=0, sel[3]=1 - Selecting sltOut (Expect 1)", test_num);
        sel = 6'b001011;
        andOut = 1'b0;
        orOut  = 1'b0;
        sltOut = 1'b1;
        FAOut  = 1'b0;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: sel[2]=0, sel[3]=1 - Selecting sltOut (Expect 0)", test_num);
        sel = 6'b111000;
        andOut = 1'b1;
        orOut  = 1'b1;
        sltOut = 1'b0;
        FAOut  = 1'b1;
        #1;

        check_outputs(1'b0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: sel[2]=0, sel[3]=0 - Selecting FAOut (Expect 1)", test_num);
        sel = 6'b000000;
        andOut = 1'b0;
        orOut  = 1'b0;
        sltOut = 1'b0;
        FAOut  = 1'b1;
        #1;

        check_outputs(1'b1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: sel[2]=0, sel[3]=0 - Selecting FAOut (Expect 0)", test_num);
        sel = 6'b110011;
        andOut = 1'b1;
        orOut  = 1'b1;
        sltOut = 1'b1;
        FAOut  = 1'b0;
        #1;

        check_outputs(1'b0);
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
        input expected_dataOut;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataOut === (expected_dataOut ^ dataOut ^ expected_dataOut)) begin
                $display("PASS");
                $display("  Outputs: dataOut=%b",
                         dataOut);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataOut=%b",
                         expected_dataOut);
                $display("  Got:      dataOut=%b",
                         dataOut);
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
