`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    wire [15:0] yss;
    wire [15:0] ysu;
    wire [15:0] yus;
    wire [15:0] yuu;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .yss(yss),
        .ysu(ysu),
        .yus(yus),
        .yuu(yuu)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        a = 8'h00;
        b = 8'h00;
        #1;

        check_outputs(16'h0000, 16'h0000, 16'h0000, 16'h0000);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        a = 8'h12;
        b = 8'h34;
        #1;

        check_outputs(16'h0036, 16'h0036, 16'h0036, 16'h0036);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        a = 8'h80;
        b = 8'h01;




        #1;





        check_outputs(16'hFF81, 16'hFF81, 16'h0081, 16'h0081);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        a = 8'h01;
        b = 8'h80;




        #1;





        check_outputs(16'hFF81, 16'h0081, 16'hFF81, 16'h0081);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        a = 8'hFF;
        b = 8'h01;




        #1;





        check_outputs(16'hFFFF, 16'hFFFF, 16'h00FF, 16'h00FF);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        a = 8'h55;
        b = 8'hAA;




        #1;





        check_outputs(16'hFFFF, 16'h00FF, 16'hFFFF, 16'h00FF);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        a = 8'h80;
        b = 8'h80;




        #1;





        check_outputs(16'hFF80, 16'hFF80, 16'hFF80, 16'h0080);
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
        input [15:0] expected_yss;
        input [15:0] expected_ysu;
        input [15:0] expected_yus;
        input [15:0] expected_yuu;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_yss === (expected_yss ^ yss ^ expected_yss) &&
                expected_ysu === (expected_ysu ^ ysu ^ expected_ysu) &&
                expected_yus === (expected_yus ^ yus ^ expected_yus) &&
                expected_yuu === (expected_yuu ^ yuu ^ expected_yuu)) begin
                $display("PASS");
                $display("  Outputs: yss=%h, ysu=%h, yus=%h, yuu=%h",
                         yss, ysu, yus, yuu);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: yss=%h, ysu=%h, yus=%h, yuu=%h",
                         expected_yss, expected_ysu, expected_yus, expected_yuu);
                $display("  Got:      yss=%h, ysu=%h, yus=%h, yuu=%h",
                         yss, ysu, yus, yuu);
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
