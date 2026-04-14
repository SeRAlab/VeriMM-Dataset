`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] BUS_ADDR;
    reg BUS_WE;
    reg CLK;
    reg RESET;
    wire [7:0] StatusLED;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .BUS_ADDR(BUS_ADDR),
        .BUS_WE(BUS_WE),
        .CLK(CLK),
        .RESET(RESET),
        .StatusLED(StatusLED)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

    begin
        RESET = 1;
        BUS_WE = 0;
        BUS_ADDR = 8'h00;
        bus_data_out = 8'h00;
        @(posedge CLK);
        #2 RESET = 0;
        @(posedge CLK);
    end
        endtask
    task testcase001;

    begin
        test_num = 1;
        $display("Testcase %0d: Write to lower 4 bits (Address 0x00)", test_num);
        reset_dut();
        bus_write(8'h00, 8'h0A);
        #1;

        check_outputs(8'h0A);
    end
        endtask

    task testcase002;

    begin
        test_num = 2;
        $display("Testcase %0d: Write to higher 4 bits (Address 0x01)", test_num);
        reset_dut();
        bus_write(8'h01, 8'h05);
        #1;

        check_outputs(8'h50);
    end
        endtask

    task testcase003;

    begin
        test_num = 3;
        $display("Testcase %0d: Sequential update of both nibbles", test_num);
        reset_dut();
        bus_write(8'h00, 8'h0F);
        bus_write(8'h01, 8'h0C);
        #1;

        check_outputs(8'hCF);
    end
        endtask

    task testcase004;

    begin
        test_num = 4;
        $display("Testcase %0d: Verify no write when BUS_WE is low", test_num);
        reset_dut();
        bus_write(8'h00, 8'h0B);

        @(posedge CLK);
        #1;
        BUS_ADDR = 8'h00;
        bus_data_out = 8'h00;
        BUS_WE = 0;
        @(posedge CLK);
        #1;
        #1;

        check_outputs(8'h0B);
    end
        endtask

    task testcase005;

    begin
        test_num = 5;
        $display("Testcase %0d: Overwrite existing register values", test_num);
        reset_dut();
        bus_write(8'h00, 8'h01);
        bus_write(8'h00, 8'h02);
        bus_write(8'h01, 8'h03);
        bus_write(8'h01, 8'h0E);
        #1;

        check_outputs(8'hE2);
    end
        endtask

    task testcase006;

    begin
        test_num = 6;
        $display("Testcase %0d: Verify reset clears the register", test_num);
        reset_dut();
        bus_write(8'h00, 8'h0F);
        bus_write(8'h01, 8'h0F);
        reset_dut();
        #1;

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
        input [7:0] expected_StatusLED;
        begin
            if (expected_StatusLED === (expected_StatusLED ^ StatusLED ^ expected_StatusLED)) begin
                $display("PASS");
                $display("  Outputs: StatusLED=%h",
                         StatusLED);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: StatusLED=%h",
                         expected_StatusLED);
                $display("  Got:      StatusLED=%h",
                         StatusLED);
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
        $dumpvars(0,BUS_ADDR, BUS_WE, CLK, RESET, StatusLED);
    end

endmodule
