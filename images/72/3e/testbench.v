`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [8:0] hp;
    reg reset;
    reg [7:0] vp;
    wire [7:0] hpos;
    wire [6:0] vpos;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .hp(hp),
        .reset(reset),
        .vp(vp),
        .hpos(hpos),
        .vpos(vpos)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Reset Check", test_num);
            reset = 1;
            hp = 9'h1FF;
            vp = 8'hFF;
            @(posedge clk);
            #1;
            reset = 0;
            @(posedge clk);


            #1;



            check_outputs(8'hFF, 7'h7F);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Minimum Values", test_num);
            reset = 1; #10; reset = 0;
            hp = 9'd0;
            vp = 8'd0;
            @(posedge clk);
            #1;

            check_outputs(8'h00, 7'h00);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Even Values (LSB=0)", test_num);
            reset = 1; #10; reset = 0;
            hp = 9'd100;
            vp = 8'd80;
            @(posedge clk);
            #1;

            check_outputs(8'd50, 7'd40);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Odd Values (LSB=1)", test_num);
            reset = 1; #10; reset = 0;
            hp = 9'd101;
            vp = 8'd81;
            @(posedge clk);
            #1;

            check_outputs(8'd50, 7'd40);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Maximum Values", test_num);
            reset = 1; #10; reset = 0;
            hp = 9'h1FF;
            vp = 8'hFF;
            @(posedge clk);
            #1;

            check_outputs(8'hFF, 7'h7F);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %0d: Pattern Shift Check", test_num);
            reset = 1; #10; reset = 0;
            hp = 9'b101010101;
            vp = 8'b01010101;
            @(posedge clk);


            #1;



            check_outputs(8'hAA, 7'h2A);
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
        input [7:0] expected_hpos;
        input [6:0] expected_vpos;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_hpos === (expected_hpos ^ hpos ^ expected_hpos) &&
                expected_vpos === (expected_vpos ^ vpos ^ expected_vpos)) begin
                $display("PASS");
                $display("  Outputs: hpos=%h, vpos=%h",
                         hpos, vpos);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: hpos=%h, vpos=%h",
                         expected_hpos, expected_vpos);
                $display("  Got:      hpos=%h, vpos=%h",
                         hpos, vpos);
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
