`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] dataa;
    reg [71:0] datab;
    reg [3:0] operation;
    reg sign;
    wire [71:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .dataa(dataa),
        .datab(datab),
        .operation(operation),
        .sign(sign),
        .dataout(dataout)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        dataa = 72'h00000000000000000A;
        datab = 72'h000000000000000005;
        operation = 4'd0;
        sign = 1'b0;
        #10;
        #1;

        check_outputs(72'h00000000000000000F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        dataa = 72'h0000000000000000FF;
        datab = 72'h00000000000000000F;
        operation = 4'd1;
        sign = 1'b0;
        #10;
        #1;

        check_outputs(72'h0000000000000000F0);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        dataa = 72'h000000000000000001;
        datab = 72'hFFFFFFFFFFFFFFFFFF;
        operation = 4'd0;
        sign = 1'b1;
        #10;
        #1;

        check_outputs(72'h000000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        dataa = 72'hFFFFFFFFFFFFFFFFFF;
        datab = 72'h000000000000000001;
        operation = 4'd1;
        sign = 1'b1;
        #10;
        #1;

        check_outputs(72'hFFFFFFFFFFFFFFFFFE);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        dataa = 72'hFFFFFFFFFFFFFFFFF0;
        datab = 72'h00000000000000000F;
        operation = 4'd0;
        sign = 1'b0;
        #10;
        #1;

        check_outputs(72'hFFFFFFFFFFFFFFFFFF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        dataa = 72'hFFFFFFFFFFFFFFFFFF;
        datab = 72'h000000000000000001;
        operation = 4'd0;
        sign = 1'b0;
        #10;
        #1;

        check_outputs(72'h000000000000000000);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        dataa = 72'h0;
        datab = 72'h0;
        operation = 4'd0;
        sign = 1'b0;
        #10;
        #1;

        check_outputs(72'h0);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        dataa = 72'h000000000000000000;
        datab = 72'h000000000000000001;
        operation = 4'd1;
        sign = 1'b1;
        #10;
        #1;

        check_outputs(72'hFFFFFFFFFFFFFFFFFF);
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
        input [71:0] expected_dataout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_dataout === (expected_dataout ^ dataout ^ expected_dataout)) begin
                $display("PASS");
                $display("  Outputs: dataout=%h",
                         dataout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: dataout=%h",
                         expected_dataout);
                $display("  Got:      dataout=%h",
                         dataout);
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
