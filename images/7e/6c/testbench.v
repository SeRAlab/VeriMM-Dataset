`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] DATA_IN;
    wire [6:0] LED_SEG;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .DATA_IN(DATA_IN),
        .LED_SEG(LED_SEG)
    );
    task testcase001;

    begin
        DATA_IN = 4'h0;
        #1;

        check_outputs(7'h7E);
    end
        endtask

    task testcase002;

    begin
        DATA_IN = 4'h1;
        #1;

        check_outputs(7'h30);
    end
        endtask

    task testcase003;

    begin
        DATA_IN = 4'h2;
        #1;

        check_outputs(7'h6D);
    end
        endtask

    task testcase004;

    begin
        DATA_IN = 4'h3;
        #1;

        check_outputs(7'h79);
    end
        endtask

    task testcase005;

    begin
        DATA_IN = 4'h4;
        #1;

        check_outputs(7'h33);
    end
        endtask

    task testcase006;

    begin
        DATA_IN = 4'h5;
        #1;

        check_outputs(7'h5B);
    end
        endtask

    task testcase007;

    begin
        DATA_IN = 4'h6;
        #1;

        check_outputs(7'h5F);
    end
        endtask

    task testcase008;

    begin
        DATA_IN = 4'h7;
        #1;

        check_outputs(7'h70);
    end
        endtask

    task testcase009;

    begin
        DATA_IN = 4'h8;
        #1;

        check_outputs(7'h7F);
    end
        endtask

    task testcase010;

    begin
        DATA_IN = 4'h9;
        #1;

        check_outputs(7'h7B);
    end
        endtask

    task testcase011;

    begin
        DATA_IN = 4'hA;
        #1;

        check_outputs(7'h77);
    end
        endtask

    task testcase012;

    begin
        DATA_IN = 4'hB;
        #1;

        check_outputs(7'h1F);
    end
        endtask

    task testcase013;

    begin
        DATA_IN = 4'hC;
        #1;

        check_outputs(7'h4E);
    end
        endtask

    task testcase014;

    begin
        DATA_IN = 4'hD;
        #1;

        check_outputs(7'h3D);
    end
        endtask

    task testcase015;

    begin
        DATA_IN = 4'hE;
        #1;

        check_outputs(7'h4F);
    end
        endtask

    task testcase016;

    begin
        DATA_IN = 4'hF;
        #1;

        check_outputs(7'h47);
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
        input [6:0] expected_LED_SEG;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_LED_SEG === (expected_LED_SEG ^ LED_SEG ^ expected_LED_SEG)) begin
                $display("PASS");
                $display("  Outputs: LED_SEG=%h",
                         LED_SEG);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LED_SEG=%h",
                         expected_LED_SEG);
                $display("  Got:      LED_SEG=%h",
                         LED_SEG);
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
