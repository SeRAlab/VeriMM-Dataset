`timescale 1ns/1ps

module LDO_tb;

    // Testbench signals (sequential circuit)
    reg [3:0] Vin;
    reg clk;
    reg enable;
    wire [3:0] Vout;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    LDO dut (
        .Vin(Vin),
        .clk(clk),
        .enable(enable),
        .Vout(Vout)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            Vin = 4'd0;
            enable = 1'b0;
            @(posedge clk);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Testcase 001: Regulation Mode (Vin=5V, En=1)");
            reset_dut();
            Vin = 4'd5;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
        end
        endtask

    task testcase002;

        begin
            $display("Testcase 002: Tracking Mode (Vin=2V, En=1)");
            reset_dut();
            Vin = 4'd2;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd2);
        end
        endtask

    task testcase003;

        begin
            $display("Testcase 003: Shutdown Mode (Vin=5V, En=0)");
            reset_dut();
            Vin = 4'd5;
            enable = 1'b0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase004;

        begin
            $display("Testcase 004: Zero Input (Vin=0V, En=1)");
            reset_dut();
            Vin = 4'd0;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    task testcase005;

        begin
            $display("Testcase 005: Boundary Condition (Vin=3V, En=1)");
            reset_dut();
            Vin = 4'd3;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd3);
        end
        endtask

    task testcase006;

        begin
            $display("Testcase 006: Transition Active to Disabled");
            reset_dut();
            Vin = 4'd4;
            enable = 1'b1;
            repeat(2) @(posedge clk);
            enable = 1'b0;
            repeat(2) @(posedge clk);
            #1 #1;
 check_outputs(4'd0);
        end
        endtask

    // Test stimulus
    initial begin
        // Initialize
        test_num = 0;
        pass_count = 0;
        fail_count = 0;

        $display("========================================");
        $display("LDO Testbench");
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
        input [3:0] expected_Vout;
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
        $dumpvars(0,Vin, clk, enable, Vout);
    end

endmodule
