`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg [6:0] rx_round;
    reg [31:0] rx_x;
    reg [31:0] rx_y;
    reg [31:0] rx_z;
    wire [31:0] tx_f;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .rx_round(rx_round),
        .rx_x(rx_x),
        .rx_y(rx_y),
        .rx_z(rx_z),
        .tx_f(tx_f)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Round 0-15 (XOR chain: x ^ y ^ z)", test_num);
            rx_round = 7'd5;
            rx_x = 32'hAAAAAAAA;
            rx_y = 32'h55555555;
            rx_z = 32'hFFFFFFFF;

            #1;


            check_outputs(32'h00000000);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Round 16-31 ((x & y) | (~x & z))", test_num);
            rx_round = 7'd20;
            rx_x = 32'hF0F0F0F0;
            rx_y = 32'hCCCC0000;
            rx_z = 32'h00003333;



            #1;




            check_outputs(32'hC0C00303);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Round 32-47 ((x | ~y) ^ z)", test_num);
            rx_round = 7'd40;
            rx_x = 32'h12345678;
            rx_y = 32'h12345678;
            rx_z = 32'hAAAAAAAA;



            #1;




            check_outputs(32'h55555555);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Round 48-63 ((x & z) | (y & ~z))", test_num);
            rx_round = 7'd55;
            rx_x = 32'hFFFF0000;
            rx_y = 32'h0000FFFF;
            rx_z = 32'hF0F0F0F0;




            #1;





            check_outputs(32'hF0F00F0F);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Round 64-79 (x ^ (y | ~z))", test_num);
            rx_round = 7'd70;
            rx_x = 32'h88888888;
            rx_y = 32'h11111111;
            rx_z = 32'h11111111;



            #1;




            check_outputs(32'h77777777);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Boundary Round 15 (XOR chain)", test_num);
            rx_round = 7'd15;
            rx_x = 32'h12345678;
            rx_y = 32'h00000000;
            rx_z = 32'h00000000;
            #1;

            check_outputs(32'h12345678);
        end
        endtask

    task testcase007;

        begin
            test_num = 7;
            $display("Testcase %0d: Boundary Round 16 (Mux function)", test_num);
            rx_round = 7'd16;
            rx_x = 32'hFFFFFFFF;
            rx_y = 32'hA5A5A5A5;
            rx_z = 32'h5A5A5A5A;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase008;

        begin
            test_num = 8;
            $display("Testcase %0d: Boundary Round 32 (OR-NOT-XOR)", test_num);
            rx_round = 7'd32;
            rx_x = 32'h00000000;
            rx_y = 32'hFFFFFFFF;
            rx_z = 32'h12345678;

            #1;


            check_outputs(32'h12345678);
        end
        endtask

    task testcase009;

        begin
            test_num = 9;
            $display("Testcase %0d: Boundary Round 48 (Reverse Mux)", test_num);
            rx_round = 7'd48;
            rx_x = 32'hA5A5A5A5;
            rx_y = 32'h5A5A5A5A;
            rx_z = 32'hFFFFFFFF;
            #1;

            check_outputs(32'hA5A5A5A5);
        end
        endtask

    task testcase010;

        begin
            test_num = 10;
            $display("Testcase %0d: All Zeros input Round 0", test_num);
            rx_round = 7'd0;
            rx_x = 32'h0;
            rx_y = 32'h0;
            rx_z = 32'h0;
            #1;

            check_outputs(32'h0);
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
        input [31:0] expected_tx_f;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_tx_f === (expected_tx_f ^ tx_f ^ expected_tx_f)) begin
                $display("PASS");
                $display("  Outputs: tx_f=%h",
                         tx_f);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: tx_f=%h",
                         expected_tx_f);
                $display("  Got:      tx_f=%h",
                         tx_f);
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
