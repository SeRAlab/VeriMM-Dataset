`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [4:0] din0;
    reg [4:0] din1;
    reg node;
    wire [4:0] dout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .din0(din0),
        .din1(din1),
        .node(node),
        .dout(dout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din0 (node=0) with zero/max inputs", test_num);
            din0 = 5'b00000;
            din1 = 5'b11111;
            node = 1'b0;
            #1;

            check_outputs(5'b00000);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din1 (node=1) with zero/max inputs", test_num);
            din0 = 5'b00000;
            din1 = 5'b11111;
            node = 1'b1;
            #1;

            check_outputs(5'b11111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din0 (node=0) with alternating bits", test_num);
            din0 = 5'b10101;
            din1 = 5'b01010;
            node = 1'b0;
            #1;

            check_outputs(5'b10101);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din1 (node=1) with alternating bits", test_num);
            din0 = 5'b10101;
            din1 = 5'b01010;
            node = 1'b1;
            #1;

            check_outputs(5'b01010);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din0 (node=0) with specific pattern", test_num);
            din0 = 5'h12;
            din1 = 5'h09;
            node = 1'b0;
            #1;

            check_outputs(5'h12);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select din1 (node=1) with specific pattern", test_num);
            din0 = 5'h12;
            din1 = 5'h09;
            node = 1'b1;
            #1;

            check_outputs(5'h09);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: node=0, both inputs same", test_num);
            din0 = 5'h1F;
            din1 = 5'h1F;
            node = 1'b0;
            #1;

            check_outputs(5'h1F);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: node=1, both inputs same", test_num);
            din0 = 5'h00;
            din1 = 5'h00;
            node = 1'b1;
            #1;

            check_outputs(5'h00);
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
        input [4:0] expected_dout;
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
