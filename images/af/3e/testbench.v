`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [2:0] AA;
    reg [2:0] BA;
    reg CLK;
    reg [2:0] DA;
    reg [15:0] D_Data;
    reg RW;
    wire [15:0] A_Data;
    wire [15:0] B_Data;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .AA(AA),
        .BA(BA),
        .CLK(CLK),
        .DA(DA),
        .D_Data(D_Data),
        .RW(RW),
        .A_Data(A_Data),
        .B_Data(B_Data)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            AA = 0;
            BA = 0;
            DA = 0;
            D_Data = 0;
            RW = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            $display("Running testcase001: Basic Write and Read back (Register 0)");
            reset_dut();


            DA = 3'b000;
            D_Data = 16'hABCD;
            RW = 1;
            @(posedge CLK);
            #1;


            RW = 0;
            AA = 3'b000;
            BA = 3'b000;
            #2;

            #1;


            check_outputs(16'hABCD, 16'hABCD);
        end
        endtask

    task testcase002;

        begin
            $display("Running testcase002: Dual Port Read (Reg 1 and Reg 2)");
            reset_dut();


            DA = 3'b001;
            D_Data = 16'h1111;
            RW = 1;
            @(posedge CLK);
            #1;


            DA = 3'b010;
            D_Data = 16'h2222;
            RW = 1;
            @(posedge CLK);
            #1;


            RW = 0;
            AA = 3'b001;
            BA = 3'b010;
            #2;

            #1;


            check_outputs(16'h1111, 16'h2222);
        end
        endtask

    task testcase003;

        begin
            $display("Running testcase003: Verify Write Enable (RW)");
            reset_dut();


            DA = 3'b011;
            D_Data = 16'h5555;
            RW = 1;
            @(posedge CLK);
            #1;


            DA = 3'b011;
            D_Data = 16'hAAAA;
            RW = 0;
            @(posedge CLK);
            #1;


            AA = 3'b011;
            BA = 3'b011;
            #2;


            #1;



            check_outputs(16'h5555, 16'h5555);
        end
        endtask

    task testcase004;

        begin
            $display("Running testcase004: Boundary Address Check (Reg 7)");
            reset_dut();


            DA = 3'b111;
            D_Data = 16'hFFFF;
            RW = 1;
            @(posedge CLK);
            #1;


            RW = 0;
            AA = 3'b111;
            BA = 3'b111;
            #2;

            #1;


            check_outputs(16'hFFFF, 16'hFFFF);
        end
        endtask

    task testcase005;

        begin
            $display("Running testcase005: Overwriting a register");
            reset_dut();


            DA = 3'b100;
            D_Data = 16'hAAAA;
            RW = 1;
            @(posedge CLK);
            #1;


            DA = 3'b100;
            D_Data = 16'h5555;
            RW = 1;
            @(posedge CLK);
            #1;


            RW = 0;
            AA = 3'b100;
            BA = 3'b100;
            #2;

            #1;


            check_outputs(16'h5555, 16'h5555);
        end
        endtask

    task testcase006;

        integer i;
        begin
            $display("Running testcase006: Multiple Register Integrity");
            reset_dut();


            for (i = 0; i < 8; i = i + 1) begin
                DA = i;
                D_Data = 16'h0100 + i;
                RW = 1;
                @(posedge CLK);
                #1;
            end


            RW = 0;
            AA = 3'b000;
            BA = 3'b111;
            #2;

            #1;


            check_outputs(16'h0100, 16'h0107);
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
        input [15:0] expected_A_Data;
        input [15:0] expected_B_Data;
        begin
            if (expected_A_Data === (expected_A_Data ^ A_Data ^ expected_A_Data) &&
                expected_B_Data === (expected_B_Data ^ B_Data ^ expected_B_Data)) begin
                $display("PASS");
                $display("  Outputs: A_Data=%h, B_Data=%h",
                         A_Data, B_Data);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: A_Data=%h, B_Data=%h",
                         expected_A_Data, expected_B_Data);
                $display("  Got:      A_Data=%h, B_Data=%h",
                         A_Data, B_Data);
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
        $dumpvars(0,AA, BA, CLK, DA, D_Data, RW, A_Data, B_Data);
    end

endmodule
