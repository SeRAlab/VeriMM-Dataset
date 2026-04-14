`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [15:0] datain;
    reg sel;
    wire [7:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain(datain),
        .sel(sel),
        .dataout(dataout)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 0 (Lower bits) with specific pattern", test_num);
            datain = 16'hA53C;
            sel = 1'b0;
            #1;

            check_outputs(8'h3C);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Select Channel 1 (Upper bits) with specific pattern", test_num);
            datain = 16'hA53C;
            sel = 1'b1;
            #1;

            check_outputs(8'hA5);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All zeros check", test_num);
            datain = 16'h0000;
            sel = 1'b0;
            #1;

            check_outputs(8'h00);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: All ones check", test_num);
            datain = 16'hFFFF;
            sel = 1'b1;
            #1;

            check_outputs(8'hFF);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits Channel 0", test_num);
            datain = 16'hFF55;
            sel = 1'b0;
            #1;

            check_outputs(8'h55);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Alternating bits Channel 1", test_num);
            datain = 16'hAA00;
            sel = 1'b1;
            #1;

            check_outputs(8'hAA);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit test Channel 0", test_num);
            datain = 16'h0001;
            sel = 1'b0;
            #1;

            check_outputs(8'h01);
        end
        endtask

    task testcase008;

        begin
            test_num = test_num + 1;
            $display("Test Case %0d: Walking bit test Channel 1", test_num);
            datain = 16'h8000;
            sel = 1'b1;
            #1;

            check_outputs(8'h80);
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
        input [7:0] expected_dataout;
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
