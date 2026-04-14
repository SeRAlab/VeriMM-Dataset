`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg HazardControl;
    reg IRQ_in;
    reg [31:0] Instruchtion_in;
    reg [31:0] PC_in;
    reg clk;
    reg reset;
    reg speccial_hazard;
    wire IRQ_out;
    wire [31:0] Instruchtion_out;
    wire [31:0] PC_out;
    wire badInstr;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .HazardControl(HazardControl),
        .IRQ_in(IRQ_in),
        .Instruchtion_in(Instruchtion_in),
        .PC_in(PC_in),
        .clk(clk),
        .reset(reset),
        .speccial_hazard(speccial_hazard),
        .IRQ_out(IRQ_out),
        .Instruchtion_out(Instruchtion_out),
        .PC_out(PC_out),
        .badInstr(badInstr)
    );

    // Clock generation (10ns period)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

        task reset_dut;

        begin
            reset = 1;
            HazardControl = 0;
            speccial_hazard = 0;
            IRQ_in = 0;
            Instruchtion_in = 32'h0;
            PC_in = 32'h0;
            @(posedge clk);
            #2 reset = 0;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Basic Data Propagation", test_num);
            reset_dut();

            PC_in = 32'h0000_1000;
            Instruchtion_in = 32'hE3A01001;
            IRQ_in = 1;
            HazardControl = 0;
            speccial_hazard = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(1, 32'hE3A01001, 32'h0000_1000, 0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Hazard Control Stall", test_num);
            reset_dut();


            PC_in = 32'h0000_2000;
            Instruchtion_in = 32'hAAAAAAAA;
            IRQ_in = 0;
            @(posedge clk);
            #2;


            HazardControl = 1;
            PC_in = 32'h0000_3000;
            Instruchtion_in = 32'hBBBBBBBB;
            IRQ_in = 1;
            @(posedge clk);
            #2;


            #1;



            check_outputs(0, 32'hAAAAAAAA, 32'h0000_2000, 0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Special Hazard Stall", test_num);
            reset_dut();


            PC_in = 32'h0000_4000;
            Instruchtion_in = 32'h11111111;
            @(posedge clk);
            #2;


            speccial_hazard = 1;
            PC_in = 32'h0000_5000;
            Instruchtion_in = 32'h22222222;
            @(posedge clk);
            #2;


            #1;



            check_outputs(0, 32'h11111111, 32'h0000_4000, 0);
        end
        endtask

    task testcase004;

        begin
            test_num = 4;
            $display("Testcase %0d: Invalid Instruction Detection", test_num);
            reset_dut();

            PC_in = 32'h0000_DEAD;
            Instruchtion_in = 32'h0000_0000;
            IRQ_in = 0;

            @(posedge clk);
            #2;


            #1;



            check_outputs(0, 32'h0000_0000, 32'h0000_DEAD, 1);
        end
        endtask

    task testcase005;

        begin
            test_num = 5;
            $display("Testcase %0d: Recovery from Stall", test_num);
            reset_dut();


            HazardControl = 1;
            PC_in = 32'h0000_F00D;
            Instruchtion_in = 32'hFFFFFFFF;
            @(posedge clk);
            #2;


            HazardControl = 0;
            @(posedge clk);
            #2;

            #1;


            check_outputs(0, 32'hFFFFFFFF, 32'h0000_F00D, 0);
        end
        endtask

    task testcase006;

        begin
            test_num = 6;
            $display("Testcase %0d: IRQ Status Persistence", test_num);
            reset_dut();

            IRQ_in = 1;
            PC_in = 32'h0000_00A0;
            Instruchtion_in = 32'h00C0FFEE;

            @(posedge clk);
            #2;

            #1;


            check_outputs(1, 32'h00C0FFEE, 32'h0000_00A0, 0);
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
        input expected_IRQ_out;
        input [31:0] expected_Instruchtion_out;
        input [31:0] expected_PC_out;
        input expected_badInstr;
        begin
            if (expected_IRQ_out === (expected_IRQ_out ^ IRQ_out ^ expected_IRQ_out) &&
                expected_Instruchtion_out === (expected_Instruchtion_out ^ Instruchtion_out ^ expected_Instruchtion_out) &&
                expected_PC_out === (expected_PC_out ^ PC_out ^ expected_PC_out) &&
                expected_badInstr === (expected_badInstr ^ badInstr ^ expected_badInstr)) begin
                $display("PASS");
                $display("  Outputs: IRQ_out=%b, Instruchtion_out=%h, PC_out=%h, badInstr=%b",
                         IRQ_out, Instruchtion_out, PC_out, badInstr);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: IRQ_out=%b, Instruchtion_out=%h, PC_out=%h, badInstr=%b",
                         expected_IRQ_out, expected_Instruchtion_out, expected_PC_out, expected_badInstr);
                $display("  Got:      IRQ_out=%b, Instruchtion_out=%h, PC_out=%h, badInstr=%b",
                         IRQ_out, Instruchtion_out, PC_out, badInstr);
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
        $dumpvars(0,HazardControl, IRQ_in, Instruchtion_in, PC_in, clk, reset, speccial_hazard, IRQ_out, Instruchtion_out, PC_out, badInstr);
    end

endmodule
