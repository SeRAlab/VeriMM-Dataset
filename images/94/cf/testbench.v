`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK_I_25MHZ;
    reg RAM_ACK_I;
    reg [15:0] RAM_DAT_I;
    reg RST_I;
    reg VFEN_I;
    reg VSYNC_I;
    wire [5:0] LB_ADR_O;
    wire [15:0] LB_DAT_O;
    wire LB_WE_O;
    wire [12:0] RAM_ADR_O;
    wire RAM_CYC_O;
    wire RAM_STB_O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK_I_25MHZ(CLK_I_25MHZ),
        .RAM_ACK_I(RAM_ACK_I),
        .RAM_DAT_I(RAM_DAT_I),
        .RST_I(RST_I),
        .VFEN_I(VFEN_I),
        .VSYNC_I(VSYNC_I),
        .LB_ADR_O(LB_ADR_O),
        .LB_DAT_O(LB_DAT_O),
        .LB_WE_O(LB_WE_O),
        .RAM_ADR_O(RAM_ADR_O),
        .RAM_CYC_O(RAM_CYC_O),
        .RAM_STB_O(RAM_STB_O)
    );

    // Clock generation (10ns period)
    initial begin
        CLK_I_25MHZ = 0;
        forever #5 CLK_I_25MHZ = ~CLK_I_25MHZ;
    end

        task reset_dut;

        begin
            RST_I = 1;
            VSYNC_I = 0;
            VFEN_I = 0;
            RAM_ACK_I = 0;
            RAM_DAT_I = 16'h0000;
            repeat(5) @(posedge CLK_I_25MHZ);
            RST_I = 0;
            repeat(2) @(posedge CLK_I_25MHZ);
        end
        endtask
    task wait_for_ram_req;

        begin
            while (!RAM_CYC_O) @(posedge CLK_I_25MHZ);
        end
        endtask

    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %03d: Initial Reset State", test_num);
            reset_dut();

            #1;


            check_outputs(6'h0, 16'h0000, 1'b0, 13'h0000, 1'b0, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %03d: Single Fetch Operation", test_num);
            reset_dut();

            VFEN_I = 1;
            wait_for_ram_req();


            @(posedge CLK_I_25MHZ);
            RAM_ACK_I = 1;
            RAM_DAT_I = 16'hABCD;

            @(posedge CLK_I_25MHZ);


            #1;
            #1;

            check_outputs(6'h0, 16'hABCD, 1'b1, 13'h0000, 1'b1, 1'b1);
            RAM_ACK_I = 0;
        end
        endtask

    task testcase003;

        integer i;
        begin
            test_num = 3;
            $display("Testcase %03d: Sequential Fetch Address Incrementing", test_num);
            reset_dut();

            VFEN_I = 1;

            for (i = 0; i < 5; i = i + 1) begin
                wait_for_ram_req();
                @(posedge CLK_I_25MHZ);
                RAM_ACK_I = 1;
                RAM_DAT_I = 16'h1000 + i;
                @(posedge CLK_I_25MHZ);
                RAM_ACK_I = 0;
            end



            #1;
            #1;

            check_outputs(6'h5, 16'h1004, 1'b0, 13'h0005, 1'b1, 1'b1);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %03d: VSYNC Resetting Address", test_num);
            reset_dut();

            VFEN_I = 1;

            repeat(2) begin
                wait_for_ram_req();
                @(posedge CLK_I_25MHZ);
                RAM_ACK_I = 1;
                @(posedge CLK_I_25MHZ);
                RAM_ACK_I = 0;
            end


            @(posedge CLK_I_25MHZ);
            VSYNC_I = 1;
            repeat(2) @(posedge CLK_I_25MHZ);
            VSYNC_I = 0;
            repeat(2) @(posedge CLK_I_25MHZ);


            #1;
            #1;

            check_outputs(6'h0, 16'h0000, 1'b0, 13'h0000, 1'b1, 1'b1);
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
        input [5:0] expected_LB_ADR_O;
        input [15:0] expected_LB_DAT_O;
        input expected_LB_WE_O;
        input [12:0] expected_RAM_ADR_O;
        input expected_RAM_CYC_O;
        input expected_RAM_STB_O;
        begin
            if (expected_LB_ADR_O === (expected_LB_ADR_O ^ LB_ADR_O ^ expected_LB_ADR_O) &&
                expected_LB_DAT_O === (expected_LB_DAT_O ^ LB_DAT_O ^ expected_LB_DAT_O) &&
                expected_LB_WE_O === (expected_LB_WE_O ^ LB_WE_O ^ expected_LB_WE_O) &&
                expected_RAM_ADR_O === (expected_RAM_ADR_O ^ RAM_ADR_O ^ expected_RAM_ADR_O) &&
                expected_RAM_CYC_O === (expected_RAM_CYC_O ^ RAM_CYC_O ^ expected_RAM_CYC_O) &&
                expected_RAM_STB_O === (expected_RAM_STB_O ^ RAM_STB_O ^ expected_RAM_STB_O)) begin
                $display("PASS");
                $display("  Outputs: LB_ADR_O=%h, LB_DAT_O=%h, LB_WE_O=%b, RAM_ADR_O=%h, RAM_CYC_O=%b, RAM_STB_O=%b",
                         LB_ADR_O, LB_DAT_O, LB_WE_O, RAM_ADR_O, RAM_CYC_O, RAM_STB_O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LB_ADR_O=%h, LB_DAT_O=%h, LB_WE_O=%b, RAM_ADR_O=%h, RAM_CYC_O=%b, RAM_STB_O=%b",
                         expected_LB_ADR_O, expected_LB_DAT_O, expected_LB_WE_O, expected_RAM_ADR_O, expected_RAM_CYC_O, expected_RAM_STB_O);
                $display("  Got:      LB_ADR_O=%h, LB_DAT_O=%h, LB_WE_O=%b, RAM_ADR_O=%h, RAM_CYC_O=%b, RAM_STB_O=%b",
                         LB_ADR_O, LB_DAT_O, LB_WE_O, RAM_ADR_O, RAM_CYC_O, RAM_STB_O);
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
        $dumpvars(0,CLK_I_25MHZ, RAM_ACK_I, RAM_DAT_I, RST_I, VFEN_I, VSYNC_I, LB_ADR_O, LB_DAT_O, LB_WE_O, RAM_ADR_O, RAM_CYC_O, RAM_STB_O);
    end

endmodule
