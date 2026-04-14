`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] in;
    wire [2:0] pos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .in(in),
        .pos(pos)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Testing highest bit (in[7])", test_num);
        in = 8'b1000_0000;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Testing bit 6", test_num);
        in = 8'b0100_0000;
        #1;

        check_outputs(3'd6);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Testing bit 5", test_num);
        in = 8'b0010_0000;
        #1;

        check_outputs(3'd5);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Testing bit 4", test_num);
        in = 8'b0001_0000;
        #1;

        check_outputs(3'd4);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Testing bit 3", test_num);
        in = 8'b0000_1000;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Testing bit 2", test_num);
        in = 8'b0000_0100;
        #1;

        check_outputs(3'd2);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: Testing bit 1", test_num);
        in = 8'b0000_0010;
        #1;

        check_outputs(3'd1);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: Testing bit 0", test_num);
        in = 8'b0000_0001;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: Default case (in=0)", test_num);
        in = 8'b0000_0000;
        #1;

        check_outputs(3'd0);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Testcase %0d: Priority check (all bits high, should be 7)", test_num);
        in = 8'b1111_1111;
        #1;

        check_outputs(3'd7);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Testcase %0d: Priority check (bits 0-3 high, should be 3)", test_num);
        in = 8'b0000_1111;
        #1;

        check_outputs(3'd3);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Testcase %0d: Priority check (bits 4 and 2 high, should be 4)", test_num);
        in = 8'b0001_0100;
        #1;

        check_outputs(3'd4);
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
        input [2:0] expected_pos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_pos === (expected_pos ^ pos ^ expected_pos)) begin
                $display("PASS");
                $display("  Outputs: pos=%h",
                         pos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: pos=%h",
                         expected_pos);
                $display("  Got:      pos=%h",
                         pos);
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
