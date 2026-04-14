`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] datain;
    wire [3:0] dataout;

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
        datain = 4'h0;
        #1;

        check_outputs(4'hC);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        datain = 4'h1;
        #1;

        check_outputs(4'h5);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        datain = 4'h2;
        #1;

        check_outputs(4'h6);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        datain = 4'h3;
        #1;

        check_outputs(4'hB);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        datain = 4'h4;
        #1;

        check_outputs(4'h9);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        datain = 4'h5;
        #1;

        check_outputs(4'h0);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        datain = 4'h6;
        #1;

        check_outputs(4'hA);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        datain = 4'h7;
        #1;

        check_outputs(4'hD);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        datain = 4'h8;
        #1;

        check_outputs(4'h3);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        datain = 4'h9;
        #1;

        check_outputs(4'hE);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        datain = 4'hA;
        #1;

        check_outputs(4'hF);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        datain = 4'hB;
        #1;

        check_outputs(4'h8);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        datain = 4'hC;
        #1;

        check_outputs(4'h4);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        datain = 4'hD;
        #1;

        check_outputs(4'h7);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        datain = 4'hE;
        #1;

        check_outputs(4'h1);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        datain = 4'hF;
        #1;

        check_outputs(4'h2);
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
        testcase013();
        testcase014();
        testcase015();
        testcase016();
        
        
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
        input [3:0] expected_dataout;
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
