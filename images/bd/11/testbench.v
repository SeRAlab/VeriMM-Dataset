`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg CON_BUS0;
    reg CON_BUS1;
    reg RESETB;
    reg clkb_1777;
    reg [2:0] clkb_bus_1777;
    reg rst_res_n;
    reg test_clk;
    reg wire_1718;
    wire A0;
    wire A1;
    wire A2;
    wire CE0;
    wire D0;
    wire D1;
    wire D2;
    wire D3;
    wire VIMDS0;
    wire VIMDS1;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CON_BUS0(CON_BUS0),
        .CON_BUS1(CON_BUS1),
        .RESETB(RESETB),
        .clkb_1777(clkb_1777),
        .clkb_bus_1777(clkb_bus_1777),
        .rst_res_n(rst_res_n),
        .test_clk(test_clk),
        .wire_1718(wire_1718),
        .A0(A0),
        .A1(A1),
        .A2(A2),
        .CE0(CE0),
        .D0(D0),
        .D1(D1),
        .D2(D2),
        .D3(D3),
        .VIMDS0(VIMDS0),
        .VIMDS1(VIMDS1)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: System Reset State", test_num);


            RESETB = 1'b0;
            rst_res_n = 1'b0;
            test_clk = 1'b0;
            wire_1718 = 1'b0;
            CON_BUS1 = 1'b0;
            CON_BUS0 = 1'b0;
            clkb_1777 = 1'b0;
            clkb_bus_1777 = 3'b000;

            #10;


            #1;



            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Clock Routing to D3", test_num);


            RESETB = 1'b1;
            rst_res_n = 1'b1;


            test_clk = 1'b1;
            wire_1718 = 1'b0;
            CON_BUS1 = 1'b0;
            CON_BUS0 = 1'b0;
            clkb_1777 = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Control Signal Routing", test_num);


            RESETB = 1'b0; rst_res_n = 1'b0; #5;
            RESETB = 1'b1; rst_res_n = 1'b1;


            test_clk = 1'b0;
            CON_BUS1 = 1'b1;
            CON_BUS0 = 1'b1;
            wire_1718 = 1'b1;
            clkb_1777 = 1'b1;

            #10;


            #1;



            check_outputs(1'b1, 1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: A2 Reset Integration Check", test_num);


            RESETB = 1'b1;
            rst_res_n = 1'b1;
            test_clk = 1'b1;
            #5;


            RESETB = 1'b0;

            #10;

            #1;


            check_outputs(1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Mixed Signal Configuration", test_num);


            RESETB = 1'b0; rst_res_n = 1'b0; #5;
            RESETB = 1'b1; rst_res_n = 1'b1;


            test_clk = 1'b1;
            wire_1718 = 1'b0;
            CON_BUS1 = 1'b1;
            CON_BUS0 = 1'b0;
            clkb_1777 = 1'b1;

            #10;

            #1;


            check_outputs(1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1, 1'b0, 1'b1);
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
        input expected_A0;
        input expected_A1;
        input expected_A2;
        input expected_CE0;
        input expected_D0;
        input expected_D1;
        input expected_D2;
        input expected_D3;
        input expected_VIMDS0;
        input expected_VIMDS1;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_A0 === (expected_A0 ^ A0 ^ expected_A0) &&
                expected_A1 === (expected_A1 ^ A1 ^ expected_A1) &&
                expected_A2 === (expected_A2 ^ A2 ^ expected_A2) &&
                expected_CE0 === (expected_CE0 ^ CE0 ^ expected_CE0) &&
                expected_D0 === (expected_D0 ^ D0 ^ expected_D0) &&
                expected_D1 === (expected_D1 ^ D1 ^ expected_D1) &&
                expected_D2 === (expected_D2 ^ D2 ^ expected_D2) &&
                expected_D3 === (expected_D3 ^ D3 ^ expected_D3) &&
                expected_VIMDS0 === (expected_VIMDS0 ^ VIMDS0 ^ expected_VIMDS0) &&
                expected_VIMDS1 === (expected_VIMDS1 ^ VIMDS1 ^ expected_VIMDS1)) begin
                $display("PASS");
                $display("  Outputs: A0=%b, A1=%b, A2=%b, CE0=%b, D0=%b, D1=%b, D2=%b, D3=%b, VIMDS0=%b, VIMDS1=%b",
                         A0, A1, A2, CE0, D0, D1, D2, D3, VIMDS0, VIMDS1);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A0=%b, A1=%b, A2=%b, CE0=%b, D0=%b, D1=%b, D2=%b, D3=%b, VIMDS0=%b, VIMDS1=%b",
                         expected_A0, expected_A1, expected_A2, expected_CE0, expected_D0, expected_D1, expected_D2, expected_D3, expected_VIMDS0, expected_VIMDS1);
                $display("  Got:      A0=%b, A1=%b, A2=%b, CE0=%b, D0=%b, D1=%b, D2=%b, D3=%b, VIMDS0=%b, VIMDS1=%b",
                         A0, A1, A2, CE0, D0, D1, D2, D3, VIMDS0, VIMDS1);
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
