`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg In0;
    reg In1;
    reg In2;
    reg [1:0] Sel;
    wire Out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .In0(In0),
        .In1(In1),
        .In2(In2),
        .Sel(Sel),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=00, In0=0", test_num);
            In0 = 0; In1 = 1; In2 = 1; Sel = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=00, In0=1", test_num);
            In0 = 1; In1 = 0; In2 = 0; Sel = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=01, In1=0", test_num);
            In0 = 1; In1 = 0; In2 = 1; Sel = 2'b01;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=01, In1=1", test_num);
            In0 = 0; In1 = 1; In2 = 0; Sel = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=10, In2=0", test_num);
            In0 = 1; In1 = 1; In2 = 0; Sel = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=10, In2=1", test_num);
            In0 = 0; In1 = 0; In2 = 1; Sel = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=11 (Default case), expect LOW", test_num);
            In0 = 1; In1 = 1; In2 = 1; Sel = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Sel=11 (Default case), Inputs all 0", test_num);
            In0 = 0; In1 = 0; In2 = 0; Sel = 2'b11;
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
