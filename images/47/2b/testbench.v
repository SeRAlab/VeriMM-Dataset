`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CE;
    reg CLK;
    reg CLR;
    reg [3:0] I;
    reg LUT_I0;
    reg LUT_I1;
    wire LUT_O;
    wire [3:0] O;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CE(CE),
        .CLK(CLK),
        .CLR(CLR),
        .I(I),
        .LUT_I0(LUT_I0),
        .LUT_I1(LUT_I1),
        .LUT_O(LUT_O),
        .O(O)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            CLR = 1;
            CE = 0;
            I = 4'b0000;
            LUT_I0 = 0;
            LUT_I1 = 0;
            @(posedge CLK);
            #1;
            CLR = 0;
            @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Basic Load", test_num);
            reset_dut();

            I = 4'b1010;
            CE = 1;
            CLR = 0;
            LUT_I0 = 0;
            LUT_I1 = 0;

            @(posedge CLK);
            #2;


            #1;



            check_outputs(LUT_O, 4'b1010);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: CE Disable", test_num);
            reset_dut();


            I = 4'b0111;
            CE = 1;
            CLR = 0;
            @(posedge CLK);
            #2;


            I = 4'b1111;
            CE = 0;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(LUT_O, 4'b0111);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Synchronous Clear", test_num);
            reset_dut();


            I = 4'b1100;
            CE = 1;
            CLR = 0;
            @(posedge CLK);
            #2;


            CLR = 1;
            @(posedge CLK);
            #2;
            #1;

            check_outputs(LUT_O, 4'b0000);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: LUT Inputs", test_num);
            reset_dut();


            LUT_I0 = 1;
            LUT_I1 = 1;
            I = 4'b0011;
            CE = 1;
            @(posedge CLK);
            #2;




            #1;





            check_outputs(LUT_O, 4'b0011);
        end
        endtask

    task testcase005;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: CLR Priority", test_num);
            reset_dut();

            I = 4'b1111;
            CE = 1;
            CLR = 1;
            @(posedge CLK);
            #2;


            #1;



            check_outputs(LUT_O, 4'b0000);
        end
        endtask

    task testcase006;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Toggle and LUT", test_num);
            reset_dut();

            I = 4'b0101;
            CE = 1;
            LUT_I0 = 1;
            LUT_I1 = 0;
            @(posedge CLK);
            #1;

            I = 4'b1010;
            CE = 1;
            LUT_I0 = 0;
            LUT_I1 = 1;
            @(posedge CLK);
            #2;

            #1;


            check_outputs(LUT_O, 4'b1010);
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
        input expected_LUT_O;
        input [3:0] expected_O;
        begin
            if (expected_LUT_O === (expected_LUT_O ^ LUT_O ^ expected_LUT_O) &&
                expected_O === (expected_O ^ O ^ expected_O)) begin
                $display("PASS");
                $display("  Outputs: LUT_O=%b, O=%h",
                         LUT_O, O);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: LUT_O=%b, O=%h",
                         expected_LUT_O, expected_O);
                $display("  Got:      LUT_O=%b, O=%h",
                         LUT_O, O);
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
        $dumpvars(0,CE, CLK, CLR, I, LUT_I0, LUT_I1, LUT_O, O);
    end

endmodule
