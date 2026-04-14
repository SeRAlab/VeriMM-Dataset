`timescale 1ns/1ps

module LDO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    reg clk;
    reg rst;
    wire [7:0] Vout;
    wire switch_ctrl;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Controller dut (
        .Vin(Vin),
        .Vref(Vref),
        .clk(clk),
        .rst(rst),
        .Vout(Vout),
        .switch_ctrl(switch_ctrl)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            rst = 1;
            Vin = 8'd0;
            Vref = 8'd0;
            @(posedge clk);
            #1;
            rst = 0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Check Reset State", test_num);
            reset_dut();
            #1;

            check_outputs(8'h00, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Normal Operation - Switch ON (Vin < Vref)", test_num);
            reset_dut();
            Vin = 8'd100;
            Vref = 8'd150;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd100, 1'b1);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Over Voltage - Switch OFF (Vout > Vref)", test_num);
            reset_dut();
            Vref = 8'd100;
            Vin = 8'd200;

            @(posedge clk);

            @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Zero Reference Voltage", test_num);
            reset_dut();
            Vin = 8'd50;
            Vref = 8'd0;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd0, 1'b0);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: High Vin and Vref", test_num);
            reset_dut();
            Vin = 8'hFF;
            Vref = 8'hFF;



            Vref = 8'hFF;
            Vin = 8'hFE;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'hFE, 1'b1);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: Dynamic Vin Change", test_num);
            reset_dut();
            Vref = 8'd100;
            Vin = 8'd80;
            repeat(2) @(posedge clk);

            Vin = 8'd40;
            repeat(2) @(posedge clk);
            #1;
            #1;

            check_outputs(8'd40, 1'b1);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Controller Testbench");
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
        input [7:0] expected_Vout;
        input expected_switch_ctrl;
        begin
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout) &&
                expected_switch_ctrl === (expected_switch_ctrl ^ switch_ctrl ^ expected_switch_ctrl)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h, switch_ctrl=%b",
                         Vout, switch_ctrl);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h, switch_ctrl=%b",
                         expected_Vout, expected_switch_ctrl);
                $display("  Got:      Vout=%h, switch_ctrl=%b",
                         Vout, switch_ctrl);
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
        $dumpvars(0,Vin, Vref, clk, rst, Vout, switch_ctrl);
    end

endmodule
