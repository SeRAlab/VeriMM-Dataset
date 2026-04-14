`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [5:0] din0;
    reg [5:0] din1;
    reg sel0;
    reg sel1;
    wire [5:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .sel0(sel0),
        .sel1(sel1),
        .dout(dout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select din0 only", test_num);
        din0 = 6'h3A; din1 = 6'h05; sel0 = 1; sel1 = 0;
        #1;

        check_outputs(6'h3A);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Select din1 only", test_num);
        din0 = 6'h3A; din1 = 6'h15; sel0 = 0; sel1 = 1;
        #1;

        check_outputs(6'h15);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: No select signals active", test_num);
        din0 = 6'h3F; din1 = 6'h3F; sel0 = 0; sel1 = 0;
        #1;

        check_outputs(6'h00);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both selects active (Expect bitwise AND)", test_num);
        din0 = 6'b110011; din1 = 6'b101010; sel0 = 1; sel1 = 1;
        #1;

        check_outputs(6'b100010);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits set on din0", test_num);
        din0 = 6'h3F; din1 = 6'h00; sel0 = 1; sel1 = 0;
        #1;

        check_outputs(6'h3F);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: All bits set on din1", test_num);
        din0 = 6'h00; din1 = 6'h3F; sel0 = 0; sel1 = 1;
        #1;

        check_outputs(6'h3F);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both active with identical inputs", test_num);
        din0 = 6'h2D; din1 = 6'h2D; sel0 = 1; sel1 = 1;
        #1;

        check_outputs(6'h2D);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        $display("Testcase %0d: Both active with complementary inputs (Expect 0)", test_num);
        din0 = 6'b101010; din1 = 6'b010101; sel0 = 1; sel1 = 1;
        #1;

        check_outputs(6'h00);
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
        input [5:0] expected_dout;
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
