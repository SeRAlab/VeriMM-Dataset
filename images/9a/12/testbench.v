`timescale 1ns/1ps

module top_module_tb;

    // Testbench signals (sequential circuit)
    reg CLK;
    reg [1:0] DIA;
    reg [1:0] DIB;
    reg [1:0] DIC;
    wire [5:0] Q;
    wire out;

    // Test tracking
    integer test_num;
    integer pass_count;
    integer fail_count;

    // Instantiate the DUT (Device Under Test)
    top_module dut (
        .CLK(CLK),
        .DIA(DIA),
        .DIB(DIB),
        .DIC(DIC),
        .Q(Q),
        .out(out)
    );

    // Clock generation (10ns period)
    initial begin
        CLK = 0;
        forever #5 CLK = ~CLK;
    end

        task reset_dut;

        begin
            DIA = 2'b00;
            DIB = 2'b00;
            DIC = 2'b00;
            repeat(5) @(posedge CLK);
            #1;
        end
        endtask
    task testcase001;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Initial State", test_num);
            reset_dut();

            #1;


            check_outputs(Q, 1'b0);
        end
        endtask

    task testcase002;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Single Write/Read Concatenation", test_num);
            reset_dut();


            DIA = 2'b01; DIB = 2'b10; DIC = 2'b11;
            @(posedge CLK);
            #1;

            DIA = 2'b00; DIB = 2'b00; DIC = 2'b00;
            @(posedge CLK);
            #1;

            #1;


            check_outputs(6'h1B, 1'b0);
        end
        endtask

    task testcase003;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: FIFO Sequential Flow", test_num);
            reset_dut();


            DIA = 2'b11; DIB = 2'b11; DIC = 2'b11;
            @(posedge CLK); #1;


            DIA = 2'b00; DIB = 2'b11; DIC = 2'b00;
            @(posedge CLK); #1;


            DIA = 2'b00; DIB = 2'b00; DIC = 2'b00;
            @(posedge CLK); #1;



            #1;




            check_outputs(6'h0C, 1'b0);
        end
        endtask

    task testcase004;

        begin
            test_num = test_num + 1;
            $display("Testcase %03d: Bit Alignment Check", test_num);
            reset_dut();

            DIA = 2'b10; DIB = 2'b00; DIC = 2'b00;
            @(posedge CLK); #1;
            DIA = 0; DIB = 0; DIC = 0;
            @(posedge CLK); #1;
            #1;

            check_outputs(6'h20, 1'b0);
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
        input [5:0] expected_Q;
        input expected_out;
        begin
            if (expected_Q === (expected_Q ^ Q ^ expected_Q) &&
                expected_out === (expected_out ^ out ^ expected_out)) begin
                $display("PASS");
                $display("  Outputs: Q=%h, out=%b",
                         Q, out);
                pass_count = pass_count + 1;
            end else begin
                $display("FAIL");
                $display("  Expected: Q=%h, out=%b",
                         expected_Q, expected_out);
                $display("  Got:      Q=%h, out=%b",
                         Q, out);
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
        $dumpvars(0,CLK, DIA, DIB, DIC, Q, out);
    end

endmodule
