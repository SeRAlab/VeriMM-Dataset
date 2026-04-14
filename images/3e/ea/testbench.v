`timescale 1ns/1ps

module BCD_to_7seg_tb;

    // Testbench signals (combinational circuit)
    reg [3:0] BCD;
    wire [6:0] seg;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    BCD_to_7seg dut (
        .BCD(BCD),
        .seg(seg)
    );
    task testcase001;

    begin
        BCD = 4'd0;
        $display("Testing BCD = 0");
        #1;

        check_outputs(7'b0111111);
    end
        endtask

    task testcase002;

    begin
        BCD = 4'd1;
        $display("Testing BCD = 1");
        #1;

        check_outputs(7'b0000110);
    end
        endtask

    task testcase003;

    begin
        BCD = 4'd2;
        $display("Testing BCD = 2");
        #1;

        check_outputs(7'b1011011);
    end
        endtask

    task testcase004;

    begin
        BCD = 4'd3;
        $display("Testing BCD = 3");
        #1;

        check_outputs(7'b1001111);
    end
        endtask

    task testcase005;

    begin
        BCD = 4'd4;
        $display("Testing BCD = 4");
        #1;

        check_outputs(7'b1100110);
    end
        endtask

    task testcase006;

    begin
        BCD = 4'd5;
        $display("Testing BCD = 5");
        #1;

        check_outputs(7'b1101101);
    end
        endtask

    task testcase007;

    begin
        BCD = 4'd6;
        $display("Testing BCD = 6");
        #1;

        check_outputs(7'b1111101);
    end
        endtask

    task testcase008;

    begin
        BCD = 4'd7;
        $display("Testing BCD = 7");
        #1;

        check_outputs(7'b0000111);
    end
        endtask

    task testcase009;

    begin
        BCD = 4'd8;
        $display("Testing BCD = 8");
        #1;

        check_outputs(7'b1111111);
    end
        endtask

    task testcase010;

    begin
        BCD = 4'd9;
        $display("Testing BCD = 9");
        #1;

        check_outputs(7'b1101111);
    end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("BCD_to_7seg Testbench");
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
        input [6:0] expected_seg;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_seg === (expected_seg ^ seg ^ expected_seg)) begin
                $display("PASS");
                $display("  Outputs: seg=%h",
                         seg);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: seg=%h",
                         expected_seg);
                $display("  Got:      seg=%h",
                         seg);
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
