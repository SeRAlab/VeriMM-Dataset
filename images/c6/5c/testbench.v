`timescale 1ns/1ps

module twosComplement_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] iNum;
    wire [3:0] oNum;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    twosComplement dut (
        .iNum(iNum),
        .oNum(oNum)
    );
    task testcase001;

    begin
        test_num = 1;
        iNum = 4'b0000;
        $display("Test %0d: Input = %b (Zero)", test_num, iNum);
        #1;

        check_outputs(4'b0000);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        iNum = 4'b0001;
        $display("Test %0d: Input = %b (One)", test_num, iNum);
        #1;

        check_outputs(4'b1111);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        iNum = 4'b0010;
        $display("Test %0d: Input = %b (Two)", test_num, iNum);
        #1;

        check_outputs(4'b1110);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        iNum = 4'b0111;
        $display("Test %0d: Input = %b (Seven)", test_num, iNum);
        #1;

        check_outputs(4'b1001);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        iNum = 4'b1000;
        $display("Test %0d: Input = %b (Eight/Negative Eight boundary)", test_num, iNum);
        #1;

        check_outputs(4'b1000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        iNum = 4'b1010;
        $display("Test %0d: Input = %b (Ten)", test_num, iNum);
        #1;

        check_outputs(4'b0110);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        iNum = 4'b1111;
        $display("Test %0d: Input = %b (Fifteen)", test_num, iNum);
        #1;

        check_outputs(4'b0001);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        iNum = 4'b0100;
        $display("Test %0d: Input = %b (Four)", test_num, iNum);
        #1;

        check_outputs(4'b1100);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("twosComplement Testbench");
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
        input [3:0] expected_oNum;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_oNum === (expected_oNum ^ oNum ^ expected_oNum)) begin
                $display("PASS");
                $display("  Outputs: oNum=%h",
                         oNum);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: oNum=%h",
                         expected_oNum);
                $display("  Got:      oNum=%h",
                         oNum);
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
