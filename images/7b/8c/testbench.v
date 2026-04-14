`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] ctrl_in;
    reg [7:0] data_in;
    wire [3:0] ctrl_out;
    wire [7:0] data_out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .ctrl_in(ctrl_in),
        .data_in(data_in),
        .ctrl_out(ctrl_out),
        .data_out(data_out)
    );

        task reset_dut;

        begin
            ctrl_in = 4'b0000;
            data_in = 8'h00;
            #10;
        end
        endtask
    task testcase001;

        begin
            reset_dut();
            test_num = 1;
            $display("Testcase %03d: Verifying control signal transparency...", test_num);

            data_in = 8'h00;
            ctrl_in = 4'b1011;
            #10;



            #1;




            check_outputs(4'b1011, data_out);
        end
        endtask

    task testcase002;

        begin
            reset_dut();
            test_num = 2;
            $display("Testcase %03d: Verifying data transmission on rising edge...", test_num);


            data_in = 8'hA5;
            #5;

            ctrl_in = 4'b0001;
            #10;


            #1;



            check_outputs(4'b0001, 8'hA5);
        end
        endtask

    task testcase003;

        begin
            reset_dut();
            test_num = 3;
            $display("Testcase %03d: Verifying data stability without rising edge...", test_num);


            data_in = 8'h12;
            ctrl_in = 4'b0001;
            #10;


            data_in = 8'h34;
            #10;


            #1;



            check_outputs(4'b0001, 8'h12);
        end
        endtask

    task testcase004;

        begin
            reset_dut();
            test_num = 4;
            $display("Testcase %03d: Verifying falling edge does not update data...", test_num);


            data_in = 8'h55;
            ctrl_in = 4'b0001;
            #10;


            data_in = 8'h66;
            ctrl_in = 4'b0000;
            #10;


            #1;



            check_outputs(4'b0000, 8'h55);
        end
        endtask

    task testcase005;

        begin
            reset_dut();
            test_num = 5;
            $display("Testcase %03d: Verifying transmission with bit combination transitions...", test_num);


            data_in = 8'hFF;
            ctrl_in = 4'b1111;
            #10;

            #1;


            check_outputs(4'b1111, 8'hFF);
        end
        endtask

    task testcase006;

        begin
            reset_dut();
            test_num = 6;
            $display("Testcase %03d: Verifying back-to-back data transmissions...", test_num);


            data_in = 8'hAA;
            ctrl_in = 4'b0001;
            #10;


            ctrl_in = 4'b0000;
            #10;


            data_in = 8'h55;
            ctrl_in = 4'b0010;
            #10;

            #1;


            check_outputs(4'b0010, 8'h55);
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
        input [3:0] expected_ctrl_out;
        input [7:0] expected_data_out;
        begin
            if (expected_ctrl_out === (expected_ctrl_out ^ ctrl_out ^ expected_ctrl_out) &&
                expected_data_out === (expected_data_out ^ data_out ^ expected_data_out)) begin
                $display("PASS");
                $display("  Outputs: ctrl_out=%h, data_out=%h",
                         ctrl_out, data_out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: ctrl_out=%h, data_out=%h",
                         expected_ctrl_out, expected_data_out);
                $display("  Got:      ctrl_out=%h, data_out=%h",
                         ctrl_out, data_out);
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
        $dumpvars(0,ctrl_in, data_in, ctrl_out, data_out);
    end

endmodule
