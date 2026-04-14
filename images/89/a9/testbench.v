`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] din;
    reg op;
    wire [31:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din(din),
        .op(op),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Zero Extension - Small value", test_num);
            op = 1'b0;
            din = 8'h15;
            #10;
            #1;

            check_outputs(32'h00000015);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Zero Extension - MSB is 1", test_num);
            op = 1'b0;
            din = 8'hA2;
            #10;
            #1;

            check_outputs(32'h000000A2);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Sign Extension - Positive value (MSB=0)", test_num);
            op = 1'b1;
            din = 8'h7F;
            #10;
            #1;

            check_outputs(32'h0000007F);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Sign Extension - Negative value (MSB=1)", test_num);
            op = 1'b1;
            din = 8'h80;
            #10;
            #1;

            check_outputs(32'hFFFFFF80);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Sign Extension - Negative value (All ones)", test_num);
            op = 1'b1;
            din = 8'hFF;
            #10;
            #1;

            check_outputs(32'hFFFFFFFF);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary - All zeros", test_num);
            op = 1'b0;
            din = 8'h00;
            #10;
            #1;

            check_outputs(32'h00000000);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary - Op change with same data", test_num);
            din = 8'hCC;
            op = 1'b0;
            #10;
            #1;

            check_outputs(32'h000000CC);
            op = 1'b1;
            #10;
            #1;

            check_outputs(32'hCCCCCC);

            #1;


            check_outputs(32'hFFFFFFCC);
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
        input [31:0] expected_dout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dout === (expected_dout ^ dout ^ expected_dout)) begin
                $display("PASS");
                $display("  Outputs: dout=%h",
                         dout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dout=%h",
                         expected_dout);
                $display("  Got:      dout=%h",
                         dout);
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
