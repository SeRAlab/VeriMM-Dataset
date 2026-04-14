`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg [7:0] Din;
    reg Ren;
    reg Wen;
    reg ck;
    reg rst;
    wire [7:0] Dout;
    wire Fempty;
    wire Ffull;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .Din(Din),
        .Ren(Ren),
        .Wen(Wen),
        .ck(ck),
        .rst(rst),
        .Dout(Dout),
        .Fempty(Fempty),
        .Ffull(Ffull)
    );

    // Clock generation (10ns period)
    initial begin
        ck = 0;
        forever #5 ck = ~ck;
    end

        task reset_dut;

        begin
            rst = 0;
            Wen = 0;
            Ren = 0;
            Din = 0;
            @(posedge ck);
            #1 rst = 1;
            @(posedge ck);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = 1;
            $display("Testcase %0d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(8'h00, 1'b1, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = 2;
            $display("Testcase %0d: Single Write/Read", test_num);
            reset_dut();


            Wen = 1; Din = 8'hA5;
            @(posedge ck);
            #1 Wen = 0;


            Ren = 1;
            @(posedge ck);
            #1 Ren = 0;


            #1;



            check_outputs(8'hA5, 1'b1, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = 3;
            $display("Testcase %0d: Multiple Write, Partial Read", test_num);
            reset_dut();


            Wen = 1; Din = 8'h11;
            @(posedge ck); #1;

            Din = 8'h22;
            @(posedge ck); #1;
            Wen = 0;


            Ren = 1;
            @(posedge ck); #1;
            Ren = 0;


            #1;



            check_outputs(8'h11, 1'b0, 1'b0);
        end
        endtask

    task testcase004;

        integer i;
        begin
            test_num = 4;
            $display("Testcase %0d: Fill FIFO", test_num);
            reset_dut();


            Wen = 1;
            for(i=0; i<8; i=i+1) begin
                Din = i + 8'h10;
                @(posedge ck); #1;
            end
            Wen = 0;




            #1;





            check_outputs(Dout, 1'b0, 1'b1);
        end
        endtask

    task testcase005;

        integer i;
        begin
            test_num = 5;
            $display("Testcase %0d: Full Write-Read Cycle", test_num);
            reset_dut();


            Wen = 1;
            Din = 8'hAA; @(posedge ck); #1;
            Din = 8'hBB; @(posedge ck); #1;
            Din = 8'hCC; @(posedge ck); #1;
            Wen = 0;


            Ren = 1;
            @(posedge ck); #1;
            @(posedge ck); #1;
            @(posedge ck); #1;
            Ren = 0;


            #1;



            check_outputs(8'hCC, 1'b1, 1'b0);
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
        input [7:0] expected_Dout;
        input expected_Fempty;
        input expected_Ffull;
        begin
            if (expected_Dout === (expected_Dout ^ Dout ^ expected_Dout) &&
                expected_Fempty === (expected_Fempty ^ Fempty ^ expected_Fempty) &&
                expected_Ffull === (expected_Ffull ^ Ffull ^ expected_Ffull)) begin
                $display("PASS");
                $display("  Outputs: Dout=%h, Fempty=%b, Ffull=%b",
                         Dout, Fempty, Ffull);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Dout=%h, Fempty=%b, Ffull=%b",
                         expected_Dout, expected_Fempty, expected_Ffull);
                $display("  Got:      Dout=%h, Fempty=%b, Ffull=%b",
                         Dout, Fempty, Ffull);
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
        $dumpvars(0,Din, Ren, Wen, ck, rst, Dout, Fempty, Ffull);
    end

endmodule
