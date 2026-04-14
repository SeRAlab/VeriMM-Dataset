`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] Input0;
    reg [4:0] Input1;
    reg Sel;
    wire [4:0] Output_Mux;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Input0(Input0),
        .Input1(Input1),
        .Sel(Sel),
        .Output_Mux(Output_Mux)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Select Input0 with specific pattern", test_num);
            Input0 = 5'b01010;
            Input1 = 5'b10101;
            Sel = 1'b0;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Select Input1 with specific pattern", test_num);
            Input0 = 5'b01010;
            Input1 = 5'b10101;
            Sel = 1'b1;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Select Input0 (All Ones)", test_num);
            Input0 = 5'b11111;
            Input1 = 5'b00000;
            Sel = 1'b0;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Select Input1 (All Zeros)", test_num);
            Input0 = 5'b11111;
            Input1 = 5'b00000;
            Sel = 1'b1;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Boundary value Input0", test_num);
            Input0 = 5'b10001;
            Input1 = 5'b01110;
            Sel = 1'b0;
            #1;

            check_outputs(5'b10001);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary value Input1", test_num);
            Input0 = 5'b10001;
            Input1 = 5'b01110;
            Sel = 1'b1;
            #1;

            check_outputs(5'b01110);
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
        input [4:0] expected_Output_Mux;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_Output_Mux === (expected_Output_Mux ^ Output_Mux ^ expected_Output_Mux)) begin
                $display("PASS");
                $display("  Outputs: Output_Mux=%h",
                         Output_Mux);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Output_Mux=%h",
                         expected_Output_Mux);
                $display("  Got:      Output_Mux=%h",
                         Output_Mux);
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
