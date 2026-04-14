`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg enable;
    reg [3:0] number;
    wire [7:0] seven_seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .enable(enable),
        .number(number),
        .seven_seg(seven_seg)
    );
    task testcase001;

    begin
        test_num = 1;
        enable = 1;
        number = 4'h0;
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        enable = 1;
        number = 4'h1;
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        enable = 1;
        number = 4'h2;
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        enable = 1;
        number = 4'h3;
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        enable = 1;
        number = 4'h4;
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        enable = 1;
        number = 4'h5;
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        enable = 1;
        number = 4'h6;
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        enable = 1;
        number = 4'h7;
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        enable = 1;
        number = 4'h8;
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        enable = 1;
        number = 4'h9;
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        enable = 1;
        number = 4'hA;
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        enable = 1;
        number = 4'hB;
        #1;

        check_outputs(8'h7C);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        enable = 1;
        number = 4'hC;
        #1;

        check_outputs(8'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        enable = 1;
        number = 4'hD;
        #1;

        check_outputs(8'h5E);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        enable = 1;
        number = 4'hE;
        #1;

        check_outputs(8'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        enable = 1;
        number = 4'hF;
        #1;

        check_outputs(8'h71);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        enable = 0;
        number = 4'h0;
        #1;

        check_outputs(8'h00);
    end
        endtask

    task testcase018;

    begin
        test_num = 18;
        enable = 0;
        number = 4'h8;
        #1;

        check_outputs(8'h00);
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
        testcase017();
        testcase018();
        
        
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
        input [7:0] expected_seven_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seven_seg === (expected_seven_seg ^ seven_seg ^ expected_seven_seg)) begin
                $display("PASS");
                $display("  Outputs: seven_seg=%h",
                         seven_seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seven_seg=%h",
                         expected_seven_seg);
                $display("  Got:      seven_seg=%h",
                         seven_seg);
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
