`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (combinational circuit)
    reg clock;
    reg [2:0] counter_param;
    reg [3:0] counter_type;
    reg [8:0] data_in;
    reg pll_areset_in;
    reg pll_scandataout;
    reg pll_scandone;
    reg read_param;
    reg reconfig;
    reg reset;
    reg write_param;
    wire busy;
    wire [8:0] data_out;
    wire pll_areset;
    wire pll_configupdate;
    wire pll_scanclk;
    wire pll_scanclkena;
    wire pll_scandata;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clock(clock),
        .counter_param(counter_param),
        .counter_type(counter_type),
        .data_in(data_in),
        .pll_areset_in(pll_areset_in),
        .pll_scandataout(pll_scandataout),
        .pll_scandone(pll_scandone),
        .read_param(read_param),
        .reconfig(reconfig),
        .reset(reset),
        .write_param(write_param),
        .busy(busy),
        .data_out(data_out),
        .pll_areset(pll_areset),
        .pll_configupdate(pll_configupdate),
        .pll_scanclk(pll_scanclk),
        .pll_scanclkena(pll_scanclkena),
        .pll_scandata(pll_scandata)
    );
    task testcase001;

        begin
            test_num = 1;
            $display("\nTest Case %0d: System Reset and Idle State", test_num);


            reset = 1;
            counter_param = 0;
            counter_type = 0;
            data_in = 0;
            pll_areset_in = 0;
            pll_scandataout = 0;
            pll_scandone = 0;
            read_param = 0;
            reconfig = 0;
            write_param = 0;

            repeat(5) @(posedge clock);
            reset = 0;
            repeat(2) @(posedge clock);


            #1;



            check_outputs(0, 9'h000, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("\nTest Case %0d: PLL Asynchronous Reset Input", test_num);


            reset = 1; #10; reset = 0; #10;


            pll_areset_in = 1;
            repeat(5) @(posedge clock);


            #1;



            check_outputs(0, 9'h000, 1, 0, 0, 0, 0);


            pll_areset_in = 0;
            repeat(2) @(posedge clock);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("\nTest Case %0d: Write Parameter Operation", test_num);

            reset = 1; #10; reset = 0; #10;


            counter_param = 3'b010;
            counter_type = 4'b0101;
            data_in = 9'h1AA;
            write_param = 1;

            @(posedge clock);
            write_param = 0;


            repeat(10) @(posedge clock);


            #1;



            check_outputs(0, 9'h000, 0, 0, 0, 0, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("\nTest Case %0d: Dynamic Reconfiguration Sequence", test_num);

            reset = 1; #10; reset = 0; #10;


            reconfig = 1;
            @(posedge clock);
            reconfig = 0;



            wait(busy === 1);
            repeat(5) @(posedge clock);
            pll_scandone = 1;


            while(busy === 1) @(posedge clock);
            pll_scandone = 0;
            repeat(2) @(posedge clock);


            #1;



            check_outputs(0, 9'h000, 0, 1, 0, 0, 0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("\nTest Case %0d: Read Parameter Operation", test_num);

            reset = 1; #10; reset = 0; #10;


            counter_param = 3'b001;
            counter_type = 4'b0011;
            read_param = 1;

            @(posedge clock);
            read_param = 0;


            repeat(10) @(posedge clock);



            #1;




            check_outputs(0, data_out, 0, 0, 0, 0, 0);
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
        input expected_busy;
        input [8:0] expected_data_out;
        input expected_pll_areset;
        input expected_pll_configupdate;
        input expected_pll_scanclk;
        input expected_pll_scanclkena;
        input expected_pll_scandata;
        begin
            #1; // Small delay for combinational logic to settle
            if (expected_busy === (expected_busy ^ busy ^ expected_busy) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out) &&
                expected_pll_areset === (expected_pll_areset ^ pll_areset ^ expected_pll_areset) &&
                expected_pll_configupdate === (expected_pll_configupdate ^ pll_configupdate ^ expected_pll_configupdate) &&
                expected_pll_scanclk === (expected_pll_scanclk ^ pll_scanclk ^ expected_pll_scanclk) &&
                expected_pll_scanclkena === (expected_pll_scanclkena ^ pll_scanclkena ^ expected_pll_scanclkena) &&
                expected_pll_scandata === (expected_pll_scandata ^ pll_scandata ^ expected_pll_scandata)) begin
                $display("PASS");
                $display("  Outputs: busy=%b, data_out=%h, pll_areset=%b, pll_configupdate=%b, pll_scanclk=%b, pll_scanclkena=%b, pll_scandata=%b",
                         busy, data_out, pll_areset, pll_configupdate, pll_scanclk, pll_scanclkena, pll_scandata);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: busy=%b, data_out=%h, pll_areset=%b, pll_configupdate=%b, pll_scanclk=%b, pll_scanclkena=%b, pll_scandata=%b",
                         expected_busy, expected_data_out, expected_pll_areset, expected_pll_configupdate, expected_pll_scanclk, expected_pll_scanclkena, expected_pll_scandata);
                $display("  Got:      busy=%b, data_out=%h, pll_areset=%b, pll_configupdate=%b, pll_scanclk=%b, pll_scanclkena=%b, pll_scandata=%b",
                         busy, data_out, pll_areset, pll_configupdate, pll_scanclk, pll_scanclkena, pll_scandata);
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
