`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg clk_in;
    wire light_clk;
    wire light_data;
    wire reset;
    wire sclk;
    wire scmd;
    wire sdata;
    wire status_led;
    wire vbat;
    wire vdd;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .clk_in(clk_in),
        .light_clk(light_clk),
        .light_data(light_data),
        .reset(reset),
        .sclk(sclk),
        .scmd(scmd),
        .sdata(sdata),
        .status_led(status_led),
        .vbat(vbat),
        .vdd(vdd)
    );

    // Clock generation (10ns period)
    initial begin
        clk_in = 0;
        forever #5 clk_in = ~clk_in;
    end

        task reset_dut;

        begin
            $display("--- Initializing / Resetting Peripheral Interface ---");
            repeat(10) @(posedge clk_in);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying Initial Power and Signal States", test_num);
            reset_dut();

            repeat(100) @(posedge clk_in);




            #1;





            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying SCLK Toggle (Half-Cycle)", test_num);



            repeat(19900) @(posedge clk_in);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Verifying SCLK Full Cycle Completion", test_num);

            repeat(20000) @(posedge clk_in);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Long-term Power and Signal Stability", test_num);

            repeat(20000) @(posedge clk_in);


            #1;



            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("\nTestcase %0d: Final Verification of Communication Pins Idle State", test_num);
            repeat(100) @(posedge clk_in);



            #1;




            check_outputs(1'b0, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b1, 1'b1, 1'b1);
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
        input expected_light_clk;
        input expected_light_data;
        input expected_reset;
        input expected_sclk;
        input expected_scmd;
        input expected_sdata;
        input expected_status_led;
        input expected_vbat;
        input expected_vdd;
        begin
            if (expected_light_clk === (expected_light_clk ^ light_clk ^ expected_light_clk) &&
                expected_light_data === (expected_light_data ^ light_data ^ expected_light_data) &&
                expected_reset === (expected_reset ^ reset ^ expected_reset) &&
                expected_sclk === (expected_sclk ^ sclk ^ expected_sclk) &&
                expected_scmd === (expected_scmd ^ scmd ^ expected_scmd) &&
                expected_sdata === (expected_sdata ^ sdata ^ expected_sdata) &&
                expected_status_led === (expected_status_led ^ status_led ^ expected_status_led) &&
                expected_vbat === (expected_vbat ^ vbat ^ expected_vbat) &&
                expected_vdd === (expected_vdd ^ vdd ^ expected_vdd)) begin
                $display("PASS");
                $display("  Outputs: light_clk=%b, light_data=%b, reset=%b, sclk=%b, scmd=%b, sdata=%b, status_led=%b, vbat=%b, vdd=%b",
                         light_clk, light_data, reset, sclk, scmd, sdata, status_led, vbat, vdd);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: light_clk=%b, light_data=%b, reset=%b, sclk=%b, scmd=%b, sdata=%b, status_led=%b, vbat=%b, vdd=%b",
                         expected_light_clk, expected_light_data, expected_reset, expected_sclk, expected_scmd, expected_sdata, expected_status_led, expected_vbat, expected_vdd);
                $display("  Got:      light_clk=%b, light_data=%b, reset=%b, sclk=%b, scmd=%b, sdata=%b, status_led=%b, vbat=%b, vdd=%b",
                         light_clk, light_data, reset, sclk, scmd, sdata, status_led, vbat, vdd);
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

    // Optional: Waveform dump for debugging
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,clk_in, light_clk, light_data, reset, sclk, scmd, sdata, status_led, vbat, vdd);
    end

endmodule
