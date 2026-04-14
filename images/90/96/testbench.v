`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] count;
    reg ready;
    wire [6:0] led;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .count(count),
        .ready(ready),
        .led(led)
    );
    task testcase001;

    begin
        test_num = 1;
        ready = 1'b0;
        count = 4'h0;
        #10;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        ready = 1'b0;
        count = 4'hF;
        #10;
        #1;

        check_outputs(7'h00);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        ready = 1'b1; count = 4'h0; #10;
        #1;

        check_outputs(7'h3F);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        ready = 1'b1; count = 4'h1; #10;
        #1;

        check_outputs(7'h06);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        ready = 1'b1; count = 4'h2; #10;
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        ready = 1'b1; count = 4'h3; #10;
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        ready = 1'b1; count = 4'h4; #10;
        #1;

        check_outputs(7'h66);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        ready = 1'b1; count = 4'h5; #10;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        ready = 1'b1; count = 4'h6; #10;
        #1;

        check_outputs(7'h7D);
    end
        endtask

    task testcase010;

    begin
        test_num = 10;
        ready = 1'b1; count = 4'h7; #10;
        #1;

        check_outputs(7'h07);
    end
        endtask

    task testcase011;

    begin
        test_num = 11;
        ready = 1'b1; count = 4'h8; #10;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase012;

    begin
        test_num = 12;
        ready = 1'b1; count = 4'h9; #10;
        #1;

        check_outputs(7'h6F);
    end
        endtask

    task testcase013;

    begin
        test_num = 13;
        ready = 1'b1; count = 4'hA; #10;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase014;

    begin
        test_num = 14;
        ready = 1'b1; count = 4'hB; #10;
        #1;

        check_outputs(7'h7C);
    end
        endtask

    task testcase015;

    begin
        test_num = 15;
        ready = 1'b1; count = 4'hC; #10;
        #1;

        check_outputs(7'h39);
    end
        endtask

    task testcase016;

    begin
        test_num = 16;
        ready = 1'b1; count = 4'hD; #10;
        #1;

        check_outputs(7'h5E);
    end
        endtask

    task testcase017;

    begin
        test_num = 17;
        ready = 1'b1; count = 4'hE; #10;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase018;

    begin
        test_num = 18;
        ready = 1'b1; count = 4'hF; #10;
        #1;

        check_outputs(7'h71);
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
        input [6:0] expected_led;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_led === (expected_led ^ led ^ expected_led)) begin
                $display("PASS");
                $display("  Outputs: led=%h",
                         led);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: led=%h",
                         expected_led);
                $display("  Got:      led=%h",
                         led);
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
