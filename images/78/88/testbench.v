`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] baud_mode;
    wire [19:0] baud_rate;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .baud_mode(baud_mode),
        .baud_rate(baud_rate)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Running Testcase %0d: baud_mode = 0", test_num);
        baud_mode = 4'd0;
        #1;

        check_outputs(20'd300);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Running Testcase %0d: baud_mode = 1", test_num);
        baud_mode = 4'd1;
        #1;

        check_outputs(20'd600);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Running Testcase %0d: baud_mode = 2", test_num);
        baud_mode = 4'd2;
        #1;

        check_outputs(20'd1200);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Running Testcase %0d: baud_mode = 3", test_num);
        baud_mode = 4'd3;
        #1;

        check_outputs(20'd2400);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Running Testcase %0d: baud_mode = 4", test_num);
        baud_mode = 4'd4;
        #1;

        check_outputs(20'd4800);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Running Testcase %0d: baud_mode = 5", test_num);
        baud_mode = 4'd5;
        #1;

        check_outputs(20'd9600);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Running Testcase %0d: baud_mode = 6", test_num);
        baud_mode = 4'd6;
        #1;

        check_outputs(20'd19200);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Running Testcase %0d: baud_mode = 7", test_num);
        baud_mode = 4'd7;
        #1;

        check_outputs(20'd38400);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Running Testcase %0d: baud_mode = 8", test_num);
        baud_mode = 4'd8;
        #1;

        check_outputs(20'd57600);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        $display("Running Testcase %0d: baud_mode = 9", test_num);
        baud_mode = 4'd9;
        #1;

        check_outputs(20'd115200);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        $display("Running Testcase %0d: baud_mode = 10 (Undefined)", test_num);
        baud_mode = 4'd10;
        #1;

        check_outputs(20'd109);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        $display("Running Testcase %0d: baud_mode = 11 (Undefined)", test_num);
        baud_mode = 4'd11;
        #1;

        check_outputs(20'd109);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        $display("Running Testcase %0d: baud_mode = 12 (Undefined)", test_num);
        baud_mode = 4'd12;
        #1;

        check_outputs(20'd109);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        $display("Running Testcase %0d: baud_mode = 13 (Undefined)", test_num);
        baud_mode = 4'd13;
        #1;

        check_outputs(20'd109);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        $display("Running Testcase %0d: baud_mode = 14 (Undefined)", test_num);
        baud_mode = 4'd14;
        #1;

        check_outputs(20'd109);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        $display("Running Testcase %0d: baud_mode = 15 (Undefined)", test_num);
        baud_mode = 4'd15;
        #1;

        check_outputs(20'd109);
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
        input [19:0] expected_baud_rate;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_baud_rate === (expected_baud_rate ^ baud_rate ^ expected_baud_rate)) begin
                $display("PASS");
                $display("  Outputs: baud_rate=%h",
                         baud_rate);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: baud_rate=%h",
                         expected_baud_rate);
                $display("  Got:      baud_rate=%h",
                         baud_rate);
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
