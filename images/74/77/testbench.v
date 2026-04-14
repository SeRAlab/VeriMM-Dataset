`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] datain;
    wire [6:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain(datain),
        .dataout(dataout)
    );
    task testcase001;

    begin
        test_num = 1;
        datain = 8'h16;
        #1;

        check_outputs(7'h45);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        datain = 8'h1E;
        #1;

        check_outputs(7'h16);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        datain = 8'h26;
        #1;

        check_outputs(7'h1E);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        datain = 8'h25;
        #1;

        check_outputs(7'h26);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        datain = 8'h2E;
        #1;

        check_outputs(7'h25);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        datain = 8'h36;
        #1;

        check_outputs(7'h2E);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        datain = 8'h3D;
        #1;

        check_outputs(7'h36);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        datain = 8'h3E;
        #1;

        check_outputs(7'h3D);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        datain = 8'h46;
        #1;

        check_outputs(7'h3E);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        datain = 8'h45;
        #1;

        check_outputs(7'h46);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        datain = 8'hFF;
        #1;

        check_outputs(7'b0000000);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        datain = 8'h00;
        #1;

        check_outputs(7'b0000000);
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
        input [6:0] expected_dataout;
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
