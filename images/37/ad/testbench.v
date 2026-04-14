`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] V_in;
    reg [7:0] V_ref;
    wire [7:0] V_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .V_in(V_in),
        .V_ref(V_ref),
        .V_out(V_out)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Normal Regulation Mode (V_in > V_ref)", test_num);
            V_in = 8'hA0;
            V_ref = 8'h64;
            #10;
            #1;

            check_outputs(8'h64);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Dropout Mode (V_in < V_ref)", test_num);
            V_in = 8'h40;
            V_ref = 8'h80;
            #10;
            #1;

            check_outputs(8'h40);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Reference Voltage", test_num);
            V_in = 8'hFF;
            V_ref = 8'h00;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Zero Input Voltage", test_num);
            V_in = 8'h00;
            V_ref = 8'h7F;
            #10;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Equal Voltages (V_in = V_ref)", test_num);
            V_in = 8'hC8;
            V_ref = 8'hC8;
            #10;
            #1;

            check_outputs(8'hC8);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Maximum Range", test_num);
            V_in = 8'hFF;
            V_ref = 8'hFE;
            #10;
            #1;

            check_outputs(8'hFE);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Low Voltage Regulation", test_num);
            V_in = 8'h05;
            V_ref = 8'h02;
            #10;
            #1;

            check_outputs(8'h02);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
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
        input [7:0] expected_V_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_V_out === (expected_V_out ^ V_out ^ expected_V_out)) begin
                $display("PASS");
                $display("  Outputs: V_out=%h",
                         V_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: V_out=%h",
                         expected_V_out);
                $display("  Got:      V_out=%h",
                         V_out);
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
