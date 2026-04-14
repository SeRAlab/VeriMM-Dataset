`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [1:0] inv_rails;
    reg [6:0] shift_onehot;
    wire [12:0] regime_onehot;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .inv_rails(inv_rails),
        .shift_onehot(shift_onehot),
        .regime_onehot(regime_onehot)
    );
    task testcase001;

        begin
            $display("Testcase 001: inv_rails=2'b00 (No rails enabled)");
            inv_rails = 2'b00;
            shift_onehot = 7'b1111111;
            #1;

            check_outputs(13'h0000);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: inv_rails=2'b01 (Lower rail enabled)");
            inv_rails = 2'b01;
            shift_onehot = 7'b0101010;

            #1;


            check_outputs(13'h002A);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: inv_rails=2'b10 (Upper rail enabled)");
            inv_rails = 2'b10;
            shift_onehot = 7'b1010101;


            #1;



            check_outputs(13'h1540);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: inv_rails=2'b11 (Both rails enabled)");
            inv_rails = 2'b11;
            shift_onehot = 7'b1100011;



            #1;




            check_outputs(13'h18E3);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: shift_onehot bit 0 (LSB)");
            shift_onehot = 7'b0000001;

            inv_rails = 2'b01; #1;
 check_outputs(13'h0001);
            inv_rails = 2'b10; #1;
 check_outputs(13'h0040);
            inv_rails = 2'b11; #1;
 check_outputs(13'h0041);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: shift_onehot bit 6 (MSB)");
            shift_onehot = 7'b1000000;

            inv_rails = 2'b01; #1;
 check_outputs(13'h0000);
            inv_rails = 2'b10; #1;
 check_outputs(13'h1000);
            inv_rails = 2'b11; #1;
 check_outputs(13'h1000);
        end
        endtask

    task testcase007;

        integer i;
        begin
            $display("Testcase 007: Walking one-hot sweep (rails=11)");
            inv_rails = 2'b11;
            for(i=0; i<7; i=i+1) begin
                shift_onehot = (7'b1 << i);
                if (i < 6)
                    #1;

                    check_outputs( ((7'b1 << i) << 6) | (7'b1 << i) );
                else
                    #1;

                    check_outputs( (7'b1 << i) << 6 );
            end
        end
        endtask

    task testcase008;

        begin
            $display("Testcase 008: shift_onehot all zero");
            shift_onehot = 7'b0000000;
            inv_rails = 2'b11;
            #1;

            check_outputs(13'h0000);
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
        input [12:0] expected_regime_onehot;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_regime_onehot === (expected_regime_onehot ^ regime_onehot ^ expected_regime_onehot)) begin
                $display("PASS");
                $display("  Outputs: regime_onehot=%h",
                         regime_onehot);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: regime_onehot=%h",
                         expected_regime_onehot);
                $display("  Got:      regime_onehot=%h",
                         regime_onehot);
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
