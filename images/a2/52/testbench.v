`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg In0;
    reg In1;
    reg In2;
    reg In3;
    reg In4;
    reg In5;
    reg [2:0] Sel;
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
        .In3(In3),
        .In4(In4),
        .In5(In5),
        .Sel(Sel),
        .Out(Out)
    );
    task testcase001;

        begin
            test_num = 1;
            In0 = 1; In1 = 0; In2 = 0; In3 = 0; In4 = 0; In5 = 0; Sel = 3'b000;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            In0 = 0; In1 = 1; In2 = 0; In3 = 0; In4 = 0; In5 = 0; Sel = 3'b001;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            In0 = 0; In1 = 0; In2 = 1; In3 = 0; In4 = 0; In5 = 0; Sel = 3'b010;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            In0 = 0; In1 = 0; In2 = 0; In3 = 1; In4 = 0; In5 = 0; Sel = 3'b011;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            In0 = 0; In1 = 0; In2 = 0; In3 = 0; In4 = 1; In5 = 0; Sel = 3'b100;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            In0 = 0; In1 = 0; In2 = 0; In3 = 0; In4 = 0; In5 = 1; Sel = 3'b101;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            In0 = 0; In1 = 1; In2 = 1; In3 = 1; In4 = 1; In5 = 1; Sel = 3'b000;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            In0 = 1; In1 = 0; In2 = 1; In3 = 1; In4 = 1; In5 = 1; Sel = 3'b001;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            In0 = 1; In1 = 1; In2 = 0; In3 = 1; In4 = 1; In5 = 1; Sel = 3'b010;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            In0 = 1; In1 = 1; In2 = 1; In3 = 0; In4 = 1; In5 = 1; Sel = 3'b011;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            test_num = 11;
            In0 = 1; In1 = 1; In2 = 1; In3 = 1; In4 = 0; In5 = 1; Sel = 3'b100;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            test_num = 12;
            In0 = 1; In1 = 1; In2 = 1; In3 = 1; In4 = 1; In5 = 0; Sel = 3'b101;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase013;

        begin
            test_num = 13;
            In0 = 1; In1 = 1; In2 = 1; In3 = 1; In4 = 1; In5 = 1; Sel = 3'b110;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase014;

        begin
            test_num = 14;
            In0 = 1; In1 = 1; In2 = 1; In3 = 1; In4 = 1; In5 = 1; Sel = 3'b111;
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
        testcase009();
        testcase010();
        testcase011();
        testcase012();
        testcase013();
        testcase014();
        
        
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
