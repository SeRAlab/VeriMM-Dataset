`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ena;
    reg [3:0] in;
    wire [15:0] out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ena(ena),
        .in(in),
        .out(out)
    );
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: ena=0, in=4'h0 - Decoder Disabled", test_num);
        ena = 1'b0;
        in = 4'h0;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: ena=1, in=4'h0 - Bit 0 active low", test_num);
        ena = 1'b1;
        in = 4'h0;
        #1;

        check_outputs(16'hFFFE);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: ena=1, in=4'h1 - Bit 1 active low", test_num);
        ena = 1'b1;
        in = 4'h1;
        #1;

        check_outputs(16'hFFFD);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: ena=1, in=4'h4 - Bit 4 active low", test_num);
        ena = 1'b1;
        in = 4'h4;
        #1;

        check_outputs(16'hFFEF);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: ena=1, in=4'h7 - Bit 7 active low", test_num);
        ena = 1'b1;
        in = 4'h7;
        #1;

        check_outputs(16'hFF7F);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: ena=1, in=4'h8 - Bit 8 active low", test_num);
        ena = 1'b1;
        in = 4'h8;
        #1;

        check_outputs(16'hFEFF);
    end
        endtask

    task testcase007;

    begin
        test_num = 7;
        $display("Testcase %0d: ena=1, in=4'hC - Bit 12 active low", test_num);
        ena = 1'b1;
        in = 4'hC;
        #1;

        check_outputs(16'hEFFF);
    end
        endtask

    task testcase008;

    begin
        test_num = 8;
        $display("Testcase %0d: ena=1, in=4'hF - Bit 15 active low", test_num);
        ena = 1'b1;
        in = 4'hF;
        #1;

        check_outputs(16'h7FFF);
    end
        endtask

    task testcase009;

    begin
        test_num = 9;
        $display("Testcase %0d: ena=0, in=4'hF - Decoder Disabled (input change ignored)", test_num);
        ena = 1'b0;
        in = 4'hF;
        #1;

        check_outputs(16'hFFFF);
    end
        endtask

    task testcase010;

        integer i;
        begin
            test_num = 10;
            $display("Testcase %0d: Sweep all inputs with ena=1", test_num);
            ena = 1'b1;
            for (i = 0; i < 16; i = i + 1) begin
                in = i;
                #1;

                check_outputs(~(16'h0001 << i));
            end
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
        input [15:0] expected_out;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: out=%h",
                         out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: out=%h",
                         expected_out);
                $display("  Got:      out=%h",
                         out);
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
