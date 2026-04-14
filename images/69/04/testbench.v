`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clk;
    reg [7:0] din;
    reg ff_d;
    wire bo5;
    wire bo6;
    wire carco;
    wire caro;
    wire ff_q;
    wire lut8o;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk(clk),
        .din(din),
        .ff_d(ff_d),
        .bo5(bo5),
        .bo6(bo6),
        .carco(carco),
        .caro(caro),
        .ff_q(ff_q),
        .lut8o(lut8o)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initializing and checking reset state", test_num);

            din = 8'b00000000;
            ff_d = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Testing Flip-Flop high transition", test_num);

            din = 8'b0; ff_d = 0;
            @(posedge clk);

            ff_d = 1;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Testing DIN[6] high", test_num);

            din = 8'b0; ff_d = 0;
            @(posedge clk);

            din = 8'b01000000;
            ff_d = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(0, 0, 0, 0, 1, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Testing DIN all ones", test_num);

            din = 8'b0; ff_d = 0;
            @(posedge clk);

            din = 8'b11111111;
            ff_d = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Testing alternating DIN and FF toggle", test_num);

            din = 8'b0; ff_d = 0;
            @(posedge clk);

            din = 8'hAA;
            ff_d = 1;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 1, 0);


            din = 8'h55;
            ff_d = 0;
            @(posedge clk);
            #2;
            #1;

            check_outputs(0, 0, 0, 0, 0, 0);
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
        input expected_bo5;
        input expected_bo6;
        input expected_carco;
        input expected_caro;
        input expected_ff_q;
        input expected_lut8o;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_bo5 === (expected_bo5 ^ bo5 ^ expected_bo5) &&
                expected_bo6 === (expected_bo6 ^ bo6 ^ expected_bo6) &&
                expected_carco === (expected_carco ^ carco ^ expected_carco) &&
                expected_caro === (expected_caro ^ caro ^ expected_caro) &&
                expected_ff_q === (expected_ff_q ^ ff_q ^ expected_ff_q) &&
                expected_lut8o === (expected_lut8o ^ lut8o ^ expected_lut8o)) begin
                $display("PASS");
                $display("  Outputs: bo5=%b, bo6=%b, carco=%b, caro=%b, ff_q=%b, lut8o=%b",
                         bo5, bo6, carco, caro, ff_q, lut8o);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: bo5=%b, bo6=%b, carco=%b, caro=%b, ff_q=%b, lut8o=%b",
                         expected_bo5, expected_bo6, expected_carco, expected_caro, expected_ff_q, expected_lut8o);
                $display("  Got:      bo5=%b, bo6=%b, carco=%b, caro=%b, ff_q=%b, lut8o=%b",
                         bo5, bo6, carco, caro, ff_q, lut8o);
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
