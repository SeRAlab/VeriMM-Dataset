`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [71:0] datain;
    reg rotate;
    reg shiftright;
    reg signa;
    reg signb;
    wire [71:0] dataout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .datain(datain),
        .rotate(rotate),
        .shiftright(shiftright),
        .signa(signa),
        .signb(signb),
        .dataout(dataout)
    );
    task testcase001;

    begin
        test_num = 1;
        datain = 72'hA5A5A5A5A5A5A5A5A5;
        rotate = 0;
        shiftright = 0;
        signa = 0;
        signb = 0;

        #1;


        check_outputs(72'hA5A5A5A5A5A5A5A5A5);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        datain = 72'h800000000000000001;
        rotate = 0;
        shiftright = 1;
        signa = 1;
        signb = 1;

        #1;


        check_outputs(72'h400000000000000000);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        datain = 72'h800000000000000001;
        rotate = 0;
        shiftright = 1;
        signa = 1;
        signb = 0;

        #1;


        check_outputs(72'hC00000000000000000);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        datain = 72'h800000000000000001;
        rotate = 1;
        shiftright = 0;
        signa = 0;
        signb = 0;

        #1;


        check_outputs(72'h000000000000000003);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        datain = 72'h800000000000000001;
        rotate = 1;
        shiftright = 1;
        signa = 0;
        signb = 0;

        #1;


        check_outputs(72'hC00000000000000000);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        datain = 72'hAAAAAAAAAAAAAAAAAA;
        rotate = 1;
        shiftright = 0;
        signa = 0;
        signb = 0;

        #1;


        check_outputs(72'h555555555555555555);
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
