`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [7:0] allbits;
    reg [1:0] twobits;
    wire bitout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .allbits(allbits),
        .twobits(twobits),
        .bitout(bitout)
    );
    task testcase001;

        begin
            allbits = 8'b00000000;
            twobits = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase002;

        begin
            allbits = 8'b11111111;
            twobits = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase003;

        begin
            allbits = 8'b00000001;
            twobits = 2'b00;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase004;

        begin
            allbits = 8'b00000000;
            twobits = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase005;

        begin
            allbits = 8'b00000011;
            twobits = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase006;

        begin
            allbits = 8'b01010101;
            twobits = 2'b00;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase007;

        begin
            allbits = 8'b01010101;
            twobits = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase008;

        begin
            allbits = 8'b10101010;
            twobits = 2'b10;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase009;

        begin
            allbits = 8'b11111111;
            twobits = 2'b01;
            #1;

            check_outputs(1'b1);
        end
        endtask

    task testcase010;

        begin
            allbits = 8'b01111111;
            twobits = 2'b10;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase011;

        begin
            allbits = 8'hA5;
            twobits = 2'b11;
            #1;

            check_outputs(1'b0);
        end
        endtask

    task testcase012;

        begin
            allbits = 8'h3C;
            twobits = 2'b01;
            #1;

            check_outputs(1'b1);
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
        input expected_bitout;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bitout === (expected_bitout ^ bitout ^ expected_bitout)) begin
                $display("PASS");
                $display("  Outputs: bitout=%b",
                         bitout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bitout=%b",
                         expected_bitout);
                $display("  Got:      bitout=%b",
                         bitout);
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
