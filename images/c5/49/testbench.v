`timescale 1ns/1ps

module mux4to1_tb;

    // Testbench signals (combinational circuit)
    reg In0;
    reg In1;
    reg In2;
    reg In3;
    reg Sel1;
    reg Sel2;
    wire Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    mux4to1 dut (
        .In0(In0),
        .In1(In1),
        .In2(In2),
        .In3(In3),
        .Sel1(Sel1),
        .Sel2(Sel2),
        .Out(Out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Test Case %0d: Select In0 (00), In0=0", test_num);
        In0 = 0; In1 = 1; In2 = 1; In3 = 1;
        Sel1 = 0; Sel2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Test Case %0d: Select In0 (00), In0=1", test_num);
        In0 = 1; In1 = 0; In2 = 0; In3 = 0;
        Sel1 = 0; Sel2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Test Case %0d: Select In1 (01), In1=0", test_num);
        In0 = 1; In1 = 0; In2 = 1; In3 = 1;
        Sel1 = 0; Sel2 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Test Case %0d: Select In1 (01), In1=1", test_num);
        In0 = 0; In1 = 1; In2 = 0; In3 = 0;
        Sel1 = 0; Sel2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Test Case %0d: Select In2 (10), In2=0", test_num);
        In0 = 1; In1 = 1; In2 = 0; In3 = 1;
        Sel1 = 1; Sel2 = 0;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Test Case %0d: Select In2 (10), In2=1", test_num);
        In0 = 0; In1 = 0; In2 = 1; In3 = 0;
        Sel1 = 1; Sel2 = 0;
        #1;

        check_outputs(1);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Test Case %0d: Select In3 (11), In3=0", test_num);
        In0 = 1; In1 = 1; In2 = 1; In3 = 0;
        Sel1 = 1; Sel2 = 1;
        #1;

        check_outputs(0);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Test Case %0d: Select In3 (11), In3=1", test_num);
        In0 = 0; In1 = 0; In2 = 0; In3 = 1;
        Sel1 = 1; Sel2 = 1;
        #1;

        check_outputs(1);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("mux4to1 Testbench");
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
        input expected_Out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Out === (expected_Out ^ Out ^ expected_Out)) begin
                $display("PASS");
                $display("  Outputs: Out=%b",
                         Out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Out=%b",
                         expected_Out);
                $display("  Got:      Out=%b",
                         Out);
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
