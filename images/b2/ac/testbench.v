`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] I0;
    reg [4:0] I1;
    reg [4:0] I2;
    reg [4:0] I3;
    reg [1:0] Sel;
    wire [4:0] o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .I0(I0),
        .I1(I1),
        .I2(I2),
        .I3(I3),
        .Sel(Sel),
        .o(o)
    );
    task testcase001;

        begin
            test_num = 1;
            I0 = 5'h0A; I1 = 5'h1F; I2 = 5'h00; I3 = 5'h15;
            Sel = 2'b00;
            $display("Testcase %0d: Sel=00 (Select I0)", test_num);
            #1;

            check_outputs(5'h0A);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            I0 = 5'h0A; I1 = 5'h1F; I2 = 5'h00; I3 = 5'h15;
            Sel = 2'b01;
            $display("Testcase %0d: Sel=01 (Select I1)", test_num);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            I0 = 5'h0A; I1 = 5'h1F; I2 = 5'h11; I3 = 5'h15;
            Sel = 2'b10;
            $display("Testcase %0d: Sel=10 (Select I2)", test_num);
            #1;

            check_outputs(5'h11);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            I0 = 5'h0A; I1 = 5'h1F; I2 = 5'h11; I3 = 5'h05;
            Sel = 2'b11;
            $display("Testcase %0d: Sel=11 (Select I3)", test_num);
            #1;

            check_outputs(5'h05);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            I0 = 5'h00; I1 = 5'h00; I2 = 5'h00; I3 = 5'h00;
            Sel = 2'b00;
            $display("Testcase %0d: All inputs 0, Select I0", test_num);
            #1;

            check_outputs(5'h00);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            I0 = 5'h1F; I1 = 5'h1F; I2 = 5'h1F; I3 = 5'h1F;
            Sel = 2'b10;
            $display("Testcase %0d: All inputs 1F, Select I2", test_num);
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            I0 = 5'h01; I1 = 5'h02; I2 = 5'h04; I3 = 5'h08;
            Sel = 2'b01;
            $display("Testcase %0d: Walking values, Select I1", test_num);
            #1;

            check_outputs(5'h02);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            I0 = 5'h12; I1 = 5'h13; I2 = 5'h14; I3 = 5'h15;
            Sel = 2'b11;
            $display("Testcase %0d: Sequential inputs, Select I3", test_num);
            #1;

            check_outputs(5'h15);
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
        input [4:0] expected_o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_o === (expected_o ^ o ^ expected_o)) begin
                $display("PASS");
                $display("  Outputs: o=%h",
                         o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: o=%h",
                         expected_o);
                $display("  Got:      o=%h",
                         o);
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
