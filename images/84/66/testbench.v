`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] sw;
    wire [7:0] hex;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .sw(sw),
        .hex(hex)
    );
    task testcase001;

    begin
        test_num = test_num + 1;
        sw = 4'h0;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h3F);
    end
        endtask

    task testcase002;

    begin
        test_num = test_num + 1;
        sw = 4'h1;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h06);
    end
        endtask

    task testcase003;

    begin
        test_num = test_num + 1;
        sw = 4'h2;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h5B);
    end
        endtask

    task testcase004;

    begin
        test_num = test_num + 1;
        sw = 4'h3;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h4F);
    end
        endtask

    task testcase005;

    begin
        test_num = test_num + 1;
        sw = 4'h4;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h66);
    end
        endtask

    task testcase006;

    begin
        test_num = test_num + 1;
        sw = 4'h5;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h6D);
    end
        endtask

    task testcase007;

    begin
        test_num = test_num + 1;
        sw = 4'h6;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h7D);
    end
        endtask

    task testcase008;

    begin
        test_num = test_num + 1;
        sw = 4'h7;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h07);
    end
        endtask

    task testcase009;

    begin
        test_num = test_num + 1;
        sw = 4'h8;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h7F);
    end
        endtask

    task testcase010;

    begin
        test_num = test_num + 1;
        sw = 4'h9;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h6F);
    end
        endtask

    task testcase011;

    begin
        test_num = test_num + 1;
        sw = 4'hA;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h77);
    end
        endtask

    task testcase012;

    begin
        test_num = test_num + 1;
        sw = 4'hB;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h7C);
    end
        endtask

    task testcase013;

    begin
        test_num = test_num + 1;
        sw = 4'hC;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h39);
    end
        endtask

    task testcase014;

    begin
        test_num = test_num + 1;
        sw = 4'hD;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h5E);
    end
        endtask

    task testcase015;

    begin
        test_num = test_num + 1;
        sw = 4'hE;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h79);
    end
        endtask

    task testcase016;

    begin
        test_num = test_num + 1;
        sw = 4'hF;
        #10;
        $display("Test %0d: sw = %h", test_num, sw);
        #1;

        check_outputs(8'h71);
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
        input [7:0] expected_hex;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hex === (expected_hex ^ hex ^ expected_hex)) begin
                $display("PASS");
                $display("  Outputs: hex=%h",
                         hex);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hex=%h",
                         expected_hex);
                $display("  Got:      hex=%h",
                         hex);
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
