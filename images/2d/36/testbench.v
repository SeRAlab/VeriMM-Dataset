`timescale 1ns/1ps

module LDO_Regulator_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Vin;
    reg clk;
    reg control;
    reg reset;
    wire [7:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO_Regulator dut (
        .Vin(Vin),
        .clk(clk),
        .control(control),
        .reset(reset),
        .Vout(Vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            Vin = 0;
            control = 0;
            @(posedge clk);
            #2 reset = 0;
            @(posedge clk);
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Reset Behavior", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Follow Mode (Control=1, Vin=0xFF)", test_num);
            reset_dut();
            Vin = 8'hFF;
            control = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'hFF);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Follow Mode (Control=1, Vin=0x55)", test_num);
            reset_dut();
            Vin = 8'h55;
            control = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'h55);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Regulate Mode (Control=0, Vin=0xFE)", test_num);
            reset_dut();
            Vin = 8'hFE;
            control = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'h7F);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Regulate Mode (Control=0, Vin=0x10)", test_num);
            reset_dut();
            Vin = 8'h10;
            control = 0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'h08);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Switching from Regulate to Follow", test_num);
            reset_dut();
            Vin = 8'hA0;
            control = 0;
            repeat(2) @(posedge clk);
            control = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'hA0);
        end
        endtask

    task testcase007;

        begin
            test_num = test_num + 1;
            $display("Test %0d: Zero Input (Vin=0x00)", test_num);
            reset_dut();
            Vin = 8'h00;
            control = 1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(8'h00);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO_Regulator Testbench");
        $display("========================================");


        testcase001();
        testcase002();
        testcase003();
        testcase004();
        testcase005();
        testcase006();
        testcase007();
        
        
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
        $dumpvars(0,Vin, clk, control, reset, Vout);
    end

endmodule
