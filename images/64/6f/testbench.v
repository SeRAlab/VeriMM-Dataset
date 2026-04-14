`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg ps2_clk_tx_1;
    reg ps2_clk_tx_2;
    reg ps2_d_tx_1;
    reg ps2_d_tx_2;
    reg ps2_keyb_clk_I;
    reg ps2_keyb_data_I;
    reg ps2_mouse_clk_I;
    reg ps2_mouse_data_I;
    wire ps2_clk_rx_1;
    wire ps2_clk_rx_2;
    wire ps2_d_rx_1;
    wire ps2_d_rx_2;
    wire ps2_keyb_clk_O;
    wire ps2_keyb_clk_T;
    wire ps2_keyb_data_O;
    wire ps2_keyb_data_T;
    wire ps2_mouse_clk_O;
    wire ps2_mouse_clk_T;
    wire ps2_mouse_data_O;
    wire ps2_mouse_data_T;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ps2_clk_tx_1(ps2_clk_tx_1),
        .ps2_clk_tx_2(ps2_clk_tx_2),
        .ps2_d_tx_1(ps2_d_tx_1),
        .ps2_d_tx_2(ps2_d_tx_2),
        .ps2_keyb_clk_I(ps2_keyb_clk_I),
        .ps2_keyb_data_I(ps2_keyb_data_I),
        .ps2_mouse_clk_I(ps2_mouse_clk_I),
        .ps2_mouse_data_I(ps2_mouse_data_I),
        .ps2_clk_rx_1(ps2_clk_rx_1),
        .ps2_clk_rx_2(ps2_clk_rx_2),
        .ps2_d_rx_1(ps2_d_rx_1),
        .ps2_d_rx_2(ps2_d_rx_2),
        .ps2_keyb_clk_O(ps2_keyb_clk_O),
        .ps2_keyb_clk_T(ps2_keyb_clk_T),
        .ps2_keyb_data_O(ps2_keyb_data_O),
        .ps2_keyb_data_T(ps2_keyb_data_T),
        .ps2_mouse_clk_O(ps2_mouse_clk_O),
        .ps2_mouse_clk_T(ps2_mouse_clk_T),
        .ps2_mouse_data_O(ps2_mouse_data_O),
        .ps2_mouse_data_T(ps2_mouse_data_T)
    );
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: All Idle (Input High, Transmit Inactive)", test_num);


            ps2_mouse_clk_I = 1'b1;
            ps2_mouse_data_I = 1'b1;
            ps2_keyb_clk_I = 1'b1;
            ps2_keyb_data_I = 1'b1;


            ps2_clk_tx_1 = 1'b1;
            ps2_d_tx_1 = 1'b1;
            ps2_clk_tx_2 = 1'b1;
            ps2_d_tx_2 = 1'b1;





            #1;






            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Mouse Activity (Mouse driving lines)", test_num);


            ps2_mouse_clk_I = 1'b0;
            ps2_mouse_data_I = 1'b1;
            ps2_keyb_clk_I = 1'b1;
            ps2_keyb_data_I = 1'b1;

            ps2_clk_tx_1 = 1'b1;
            ps2_d_tx_1 = 1'b1;
            ps2_clk_tx_2 = 1'b1;
            ps2_d_tx_2 = 1'b1;


            #1;



            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Keyboard Activity (Keyboard driving lines)", test_num);

            ps2_mouse_clk_I = 1'b1;
            ps2_mouse_data_I = 1'b1;

            ps2_keyb_clk_I = 1'b1;
            ps2_keyb_data_I = 1'b0;

            ps2_clk_tx_1 = 1'b1;
            ps2_d_tx_1 = 1'b1;
            ps2_clk_tx_2 = 1'b1;
            ps2_d_tx_2 = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Controller Transmit to Mouse (Driving Mouse lines)", test_num);

            ps2_mouse_clk_I = 1'b1;
            ps2_mouse_data_I = 1'b1;
            ps2_keyb_clk_I = 1'b1;
            ps2_keyb_data_I = 1'b1;


            ps2_clk_tx_1 = 1'b0;
            ps2_d_tx_1 = 1'b1;
            ps2_clk_tx_2 = 1'b1;
            ps2_d_tx_2 = 1'b1;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Controller Transmit to Keyboard (Driving Keyboard lines)", test_num);

            ps2_mouse_clk_I = 1'b1;
            ps2_mouse_data_I = 1'b1;
            ps2_keyb_clk_I = 1'b1;
            ps2_keyb_data_I = 1'b1;

            ps2_clk_tx_1 = 1'b1;
            ps2_d_tx_1 = 1'b1;

            ps2_clk_tx_2 = 1'b1;
            ps2_d_tx_2 = 1'b0;


            #1;



            check_outputs(1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("\nTest Case %0d: Simultaneous Interaction", test_num);


            ps2_mouse_clk_I = 1'b0;
            ps2_mouse_data_I = 1'b0;
            ps2_keyb_clk_I = 1'b1;
            ps2_keyb_data_I = 1'b1;


            ps2_clk_tx_1 = 1'b1;
            ps2_d_tx_1 = 1'b1;
            ps2_clk_tx_2 = 1'b0;
            ps2_d_tx_2 = 1'b0;


            #1;



            check_outputs(1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_ps2_clk_rx_1;
        input expected_ps2_clk_rx_2;
        input expected_ps2_d_rx_1;
        input expected_ps2_d_rx_2;
        input expected_ps2_keyb_clk_O;
        input expected_ps2_keyb_clk_T;
        input expected_ps2_keyb_data_O;
        input expected_ps2_keyb_data_T;
        input expected_ps2_mouse_clk_O;
        input expected_ps2_mouse_clk_T;
        input expected_ps2_mouse_data_O;
        input expected_ps2_mouse_data_T;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_ps2_clk_rx_1 === (expected_ps2_clk_rx_1 ^ ps2_clk_rx_1 ^ expected_ps2_clk_rx_1) &&
                expected_ps2_clk_rx_2 === (expected_ps2_clk_rx_2 ^ ps2_clk_rx_2 ^ expected_ps2_clk_rx_2) &&
                expected_ps2_d_rx_1 === (expected_ps2_d_rx_1 ^ ps2_d_rx_1 ^ expected_ps2_d_rx_1) &&
                expected_ps2_d_rx_2 === (expected_ps2_d_rx_2 ^ ps2_d_rx_2 ^ expected_ps2_d_rx_2) &&
                expected_ps2_keyb_clk_O === (expected_ps2_keyb_clk_O ^ ps2_keyb_clk_O ^ expected_ps2_keyb_clk_O) &&
                expected_ps2_keyb_clk_T === (expected_ps2_keyb_clk_T ^ ps2_keyb_clk_T ^ expected_ps2_keyb_clk_T) &&
                expected_ps2_keyb_data_O === (expected_ps2_keyb_data_O ^ ps2_keyb_data_O ^ expected_ps2_keyb_data_O) &&
                expected_ps2_keyb_data_T === (expected_ps2_keyb_data_T ^ ps2_keyb_data_T ^ expected_ps2_keyb_data_T) &&
                expected_ps2_mouse_clk_O === (expected_ps2_mouse_clk_O ^ ps2_mouse_clk_O ^ expected_ps2_mouse_clk_O) &&
                expected_ps2_mouse_clk_T === (expected_ps2_mouse_clk_T ^ ps2_mouse_clk_T ^ expected_ps2_mouse_clk_T) &&
                expected_ps2_mouse_data_O === (expected_ps2_mouse_data_O ^ ps2_mouse_data_O ^ expected_ps2_mouse_data_O) &&
                expected_ps2_mouse_data_T === (expected_ps2_mouse_data_T ^ ps2_mouse_data_T ^ expected_ps2_mouse_data_T)) begin
                $display("PASS");
                $display("  Outputs: ps2_clk_rx_1=%b, ps2_clk_rx_2=%b, ps2_d_rx_1=%b, ps2_d_rx_2=%b, ps2_keyb_clk_O=%b, ps2_keyb_clk_T=%b, ps2_keyb_data_O=%b, ps2_keyb_data_T=%b, ps2_mouse_clk_O=%b, ps2_mouse_clk_T=%b, ps2_mouse_data_O=%b, ps2_mouse_data_T=%b",
                         ps2_clk_rx_1, ps2_clk_rx_2, ps2_d_rx_1, ps2_d_rx_2, ps2_keyb_clk_O, ps2_keyb_clk_T, ps2_keyb_data_O, ps2_keyb_data_T, ps2_mouse_clk_O, ps2_mouse_clk_T, ps2_mouse_data_O, ps2_mouse_data_T);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ps2_clk_rx_1=%b, ps2_clk_rx_2=%b, ps2_d_rx_1=%b, ps2_d_rx_2=%b, ps2_keyb_clk_O=%b, ps2_keyb_clk_T=%b, ps2_keyb_data_O=%b, ps2_keyb_data_T=%b, ps2_mouse_clk_O=%b, ps2_mouse_clk_T=%b, ps2_mouse_data_O=%b, ps2_mouse_data_T=%b",
                         expected_ps2_clk_rx_1, expected_ps2_clk_rx_2, expected_ps2_d_rx_1, expected_ps2_d_rx_2, expected_ps2_keyb_clk_O, expected_ps2_keyb_clk_T, expected_ps2_keyb_data_O, expected_ps2_keyb_data_T, expected_ps2_mouse_clk_O, expected_ps2_mouse_clk_T, expected_ps2_mouse_data_O, expected_ps2_mouse_data_T);
                $display("  Got:      ps2_clk_rx_1=%b, ps2_clk_rx_2=%b, ps2_d_rx_1=%b, ps2_d_rx_2=%b, ps2_keyb_clk_O=%b, ps2_keyb_clk_T=%b, ps2_keyb_data_O=%b, ps2_keyb_data_T=%b, ps2_mouse_clk_O=%b, ps2_mouse_clk_T=%b, ps2_mouse_data_O=%b, ps2_mouse_data_T=%b",
                         ps2_clk_rx_1, ps2_clk_rx_2, ps2_d_rx_1, ps2_d_rx_2, ps2_keyb_clk_O, ps2_keyb_clk_T, ps2_keyb_data_O, ps2_keyb_data_T, ps2_mouse_clk_O, ps2_mouse_clk_T, ps2_mouse_data_O, ps2_mouse_data_T);
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
