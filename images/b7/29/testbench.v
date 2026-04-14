`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] a;
    reg [7:0] b;
    reg [7:0] c;
    reg [7:0] d;
    wire [7:0] final_output;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .a(a),
        .b(b),
        .c(c),
        .d(d),
        .final_output(final_output)
    );
    task testcase001;

    begin
        test_num = 1;
        a = 8'd200; b = 8'd100; c = 8'd50; d = 8'd25;


        #1;



        check_outputs(8'd200);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        a = 8'd100; b = 8'd200; c = 8'd50; d = 8'd25;


        #1;



        check_outputs(8'd100);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        a = 8'd100; b = 8'd50; c = 8'd200; d = 8'd25;


        #1;



        check_outputs(8'd50);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        a = 8'd100; b = 8'd50; c = 8'd25; d = 8'd200;


        #1;



        check_outputs(8'd25);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        a = 8'd150; b = 8'd150; c = 8'd0; d = 8'd0;


        #1;



        check_outputs(8'd75);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        a = 8'd0; b = 8'd0; c = 8'd120; d = 8'd120;


        #1;



        check_outputs(8'd15);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        a = 8'd80; b = 8'd80; c = 8'd80; d = 8'd80;


        #1;



        check_outputs(8'd10);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd0;


        #1;



        check_outputs(8'd0);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        a = 8'd255; b = 8'd0; c = 8'd0; d = 8'd0;


        #1;



        check_outputs(8'd255);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        a = 8'd255; b = 8'd255; c = 8'd255; d = 8'd255;


        #1;



        check_outputs(8'd31);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        a = 8'd1; b = 8'd0; c = 8'd0; d = 8'd0;


        #1;



        check_outputs(8'd1);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        a = 8'd0; b = 8'd0; c = 8'd0; d = 8'd1;


        #1;



        check_outputs(8'd0);
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
        input [7:0] expected_final_output;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_final_output === (expected_final_output ^ final_output ^ expected_final_output)) begin
                $display("PASS");
                $display("  Outputs: final_output=%h",
                         final_output);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: final_output=%h",
                         expected_final_output);
                $display("  Got:      final_output=%h",
                         final_output);
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
