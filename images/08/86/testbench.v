`timescale 1ns/1ps

module LDO_Controller_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vin;
    reg [7:0] Vref;
    reg clk;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Controller dut (
        .Vin(Vin),
        .Vref(Vref),
        .clk(clk),
        .Vout(Vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Vin = 8'h00;
            Vref = 8'h00;
            repeat (5) @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            reset_dut();
            Vin = 8'd200;
            Vref = 8'd100;

            repeat (20) @(posedge clk);
            $display("Testcase %0d: Standard Regulation (Vin=200, Vref=100)", test_num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            reset_dut();
            Vin = 8'd150;
            Vref = 8'd200;
            repeat (20) @(posedge clk);
            $display("Testcase %0d: Dropout Condition (Vin=150, Vref=200)", test_num);

            #1;


            check_outputs(8'd150);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            reset_dut();
            Vin = 8'd255;
            Vref = 8'd0;
            repeat (20) @(posedge clk);
            $display("Testcase %0d: Zero Reference (Vin=255, Vref=0)", test_num);
            #1;

            check_outputs(8'd0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            reset_dut();
            Vin = 8'd255;
            Vref = 8'd255;
            repeat (20) @(posedge clk);
            $display("Testcase %0d: Maximum Capacity (Vin=255, Vref=255)", test_num);
            #1;

            check_outputs(8'd255);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            reset_dut();
            Vin = 8'd105;
            Vref = 8'd100;
            repeat (20) @(posedge clk);
            $display("Testcase %0d: Small Differential (Vin=105, Vref=100)", test_num);
            #1;

            check_outputs(8'd100);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            reset_dut();
            Vin = 8'd200;
            Vref = 8'd150;
            repeat (10) @(posedge clk);
            Vin = 8'd120;
            repeat (20) @(posedge clk);
            $display("Testcase %0d: Supply Voltage Drop (Vin 200->120, Vref=150)", test_num);
            #1;

            check_outputs(8'd120);
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
        begin
            if (expected_Vout === (expected_Vout ^ Vout ^ expected_Vout)) begin
                $display("PASS");
                $display("  Outputs: Vout=%h",
                         Vout);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Vout=%h",
                         expected_Vout);
                $display("  Got:      Vout=%h",
                         Vout);
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
        $dumpvars(0,Vin, Vref, clk, Vout);
    end

endmodule
